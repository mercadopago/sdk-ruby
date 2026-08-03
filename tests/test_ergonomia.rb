# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/mercadopago'

class TestErgonomia < Minitest::Test
  # ── Exception hierarchy ─────────────────────────────────────────────────────

  def test_all_subtypes_inherit_from_base
    [Mercadopago::MPBadRequestError, Mercadopago::MPAuthenticationError,
     Mercadopago::MPPaymentError, Mercadopago::MPForbiddenError,
     Mercadopago::MPNotFoundError, Mercadopago::MPIdempotencyError,
     Mercadopago::MPValidationError, Mercadopago::MPResourceLockedError,
     Mercadopago::MPDependencyError, Mercadopago::MPRateLimitError,
     Mercadopago::MPServerError].each do |klass|
      err = klass.new(400, 'message' => 'test')
      assert_kind_of Mercadopago::MercadoPagoError, err
      assert_kind_of StandardError, err
    end
  end

  def test_rate_limit_error_stores_retry_after
    err = Mercadopago::MPRateLimitError.new(429, { 'message' => 'rate limited' }, 45)
    assert_equal 45, err.retry_after
  end

  def test_rate_limit_error_nil_retry_after
    err = Mercadopago::MPRateLimitError.new(429, {})
    assert_nil err.retry_after
  end

  def test_catch_by_base_catches_subtype
    err = Mercadopago::MPNotFoundError.new(404, {})
    caught = false
    begin; raise err; rescue Mercadopago::MercadoPagoError; caught = true; end
    assert caught
  end

  # ── build_error factory ────────────────────────────────────────────────────

  def test_factory_400; assert_kind_of Mercadopago::MPBadRequestError,      Mercadopago.build_error(400, {}); end
  def test_factory_401; assert_kind_of Mercadopago::MPAuthenticationError,  Mercadopago.build_error(401, {}); end
  def test_factory_402; assert_kind_of Mercadopago::MPPaymentError,         Mercadopago.build_error(402, {}); end
  def test_factory_403; assert_kind_of Mercadopago::MPForbiddenError,       Mercadopago.build_error(403, {}); end
  def test_factory_404; assert_kind_of Mercadopago::MPNotFoundError,        Mercadopago.build_error(404, {}); end
  def test_factory_409; assert_kind_of Mercadopago::MPIdempotencyError,     Mercadopago.build_error(409, {}); end
  def test_factory_429; assert_kind_of Mercadopago::MPRateLimitError,       Mercadopago.build_error(429, {}); end
  def test_factory_500; assert_kind_of Mercadopago::MPServerError,          Mercadopago.build_error(500, {}); end

  def test_factory_unknown_returns_base
    err = Mercadopago.build_error(418, {})
    assert_equal Mercadopago::MercadoPagoError, err.class
  end

  # ── MPResponse ────────────────────────────────────────────────────────────

  def test_mp_response_is_hash_subclass
    r = Mercadopago::MPResponse.new({ status: 200, response: { id: 1 } })
    assert_kind_of Hash, r
    assert_equal 200, r[:status]
  end

  def test_mp_response_success_2xx
    assert Mercadopago::MPResponse.new({ status: 200, response: {} }).success?
    assert Mercadopago::MPResponse.new({ status: 201, response: {} }).success?
  end

  def test_mp_response_not_success_4xx
    refute Mercadopago::MPResponse.new({ status: 400, response: {} }).success?
  end

  def test_raise_for_status_ok_no_raise
    r = Mercadopago::MPResponse.new({ status: 200, response: {} })
    r.raise_for_status!
  end

  def test_raise_for_status_4xx_raises_typed
    r = Mercadopago::MPResponse.new({ status: 401, response: { 'message' => 'unauthorized' } })
    assert_raises(Mercadopago::MPAuthenticationError) { r.raise_for_status! }
  end

  def test_raise_for_status_5xx_raises_server_error
    r = Mercadopago::MPResponse.new({ status: 500, response: {} })
    assert_raises(Mercadopago::MPServerError) { r.raise_for_status! }
  end

  # ── RequestOptions DEFAULT constants ─────────────────────────────────────

  def test_default_retry_on_includes_429
    assert_includes Mercadopago::RequestOptions::DEFAULT_RETRY_ON, 429
  end

  def test_default_retry_on_includes_5xx
    [500, 502, 503, 504].each { |c| assert_includes Mercadopago::RequestOptions::DEFAULT_RETRY_ON, c }
  end

  # ── Auto-pagination ────────────────────────────────────────────────────────

  def test_pagination_yields_all_items
    call_count = 0
    search_fn = lambda do |filters, _opts|
      call_count += 1
      offset = (filters[:offset] || 0).to_i
      if offset < 2
        { status: 200, response: { 'results' => [{ 'id' => offset }], 'paging' => { 'total' => 2, 'limit' => 1, 'offset' => offset } } }
      else
        { status: 200, response: { 'results' => [], 'paging' => { 'total' => 2 } } }
      end
    end
    iter = Mercadopago::Pagination::Iterator.new(search_fn, limit: 1)
    assert_equal 2, iter.to_a.size
  end

  def test_pagination_stops_on_empty_results
    search_fn = lambda { |_f, _o| { status: 200, response: { 'results' => [], 'paging' => { 'total' => 0 } } } }
    assert_equal [], Mercadopago::Pagination::Iterator.new(search_fn).to_a
  end

  def test_payment_resource_has_search_auto_paging_iter
    sdk = Mercadopago::SDK.new('TEST-TOKEN')
    assert_respond_to sdk.payment, :search_auto_paging_iter
  end
end

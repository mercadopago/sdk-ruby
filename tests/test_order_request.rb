# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'
require 'json'

# Covers the typed Order::Request model and the dual-acceptance behavior of
# Order#create (E2E-1 .. E2E-4). Uses a capturing HTTP client stub so no live
# API/auth is needed.
class TestOrderRequest < Minitest::Test
  Request = Mercadopago::Order::Request

  class CaptureHttpClient < Mercadopago::HttpClient
    attr_reader :last_post

    def post(url:, data:, headers:, timeout: nil)
      @last_post = { url: url, data: data, headers: headers, timeout: timeout }
      { status: 201, response: { 'id' => 'ORD123' } }
    end
  end

  def sdk_with_capture
    http_client = CaptureHttpClient.new
    [Mercadopago::SDK.new('ACCESS_TOKEN', http_client: http_client), http_client]
  end

  def posted_json(http_client)
    JSON.parse(http_client.last_post[:data])
  end

  # ---- unit: to_hash / snake_case / recursion ----

  def test_to_hash_produces_snake_case_keys
    req = Request::CreateRequest.new(
      type: 'online',
      total_amount: '1000.00',
      external_reference: 'ext_ref_1234',
      payer: Request::PayerRequest.new(email: 'buyer@example.com')
    )

    hash = req.to_hash

    assert_equal 'online', hash[:type]
    assert_equal '1000.00', hash[:total_amount]
    assert_equal 'ext_ref_1234', hash[:external_reference]
    assert_equal({ email: 'buyer@example.com' }, hash[:payer])
  end

  def test_to_hash_recurses_into_nested_objects_and_arrays
    req = Request::CreateRequest.new(
      type: 'online',
      transactions: Request::TransactionRequest.new(
        payments: [
          Request::PaymentRequest.new(
            amount: '1000.00',
            payment_method: Request::PaymentMethodRequest.new(id: 'master', type: 'credit_card', installments: 1)
          )
        ]
      ),
      items: [
        Request::ItemRequest.new(title: 'Flight', quantity: 1, unit_price: '450.00')
      ]
    )

    hash = req.to_hash

    assert_kind_of Hash, hash[:transactions]
    assert_kind_of Array, hash[:transactions][:payments]
    payment = hash[:transactions][:payments].first
    assert_equal '1000.00', payment[:amount]
    assert_equal({ id: 'master', type: 'credit_card', installments: 1 }, payment[:payment_method])
    assert_equal 'Flight', hash[:items].first[:title]
    assert_equal 1, hash[:items].first[:quantity]
  end

  # ---- E2E-4: nil omission ----

  def test_nil_fields_are_omitted
    req = Request::CreateRequest.new(type: 'online', total_amount: '10.00')

    hash = req.to_hash

    assert_equal({ type: 'online', total_amount: '10.00' }, hash)
    refute hash.key?(:currency)
    refute hash.key?(:payer)
    refute hash.key?(:transactions)
  end

  def test_nested_nil_fields_are_omitted
    pm = Request::PaymentMethodRequest.new(id: 'pix', type: 'bank_transfer')

    hash = pm.to_hash

    assert_equal({ id: 'pix', type: 'bank_transfer' }, hash)
    refute hash.key?(:token)
    refute hash.key?(:installments)
  end

  # ---- E2E-1: existing Hash path still works ----

  def test_create_still_accepts_hash
    sdk, http_client = sdk_with_capture
    order_hash = {
      type: 'online',
      total_amount: '1000.00',
      external_reference: 'ext_ref_1234',
      transactions: {
        payments: [
          { amount: '1000.00', payment_method: { id: 'pix', type: 'bank_transfer' } }
        ]
      },
      payer: { email: 'buyer@example.com' }
    }

    result = sdk.order.create(order_hash)

    assert_equal 201, result[:status]
    assert_equal 'https://api.mercadopago.com/v1/orders', http_client.last_post[:url]
    assert_equal order_hash, symbolize(posted_json(http_client))
  end

  def test_create_rejects_invalid_type
    sdk, = sdk_with_capture

    assert_raises(TypeError) { sdk.order.create('invalid') }
    assert_raises(TypeError) { sdk.order.create(42) }
  end

  # ---- E2E-2: Hash vs typed object produce identical JSON ----

  def test_hash_and_typed_produce_identical_json
    order_hash = {
      type: 'online',
      total_amount: '1000.00',
      external_reference: 'ext_ref_1234',
      transactions: {
        payments: [
          {
            amount: '1000.00',
            payment_method: { id: 'master', type: 'credit_card', installments: 1 }
          }
        ]
      },
      payer: {
        email: 'buyer@example.com',
        identification: { type: 'CPF', number: '12345678909' }
      },
      items: [
        { title: 'Flight', quantity: 1, unit_price: '1000.00', type: 'travel' }
      ]
    }

    typed = Request::CreateRequest.new(
      type: 'online',
      total_amount: '1000.00',
      external_reference: 'ext_ref_1234',
      transactions: Request::TransactionRequest.new(
        payments: [
          Request::PaymentRequest.new(
            amount: '1000.00',
            payment_method: Request::PaymentMethodRequest.new(
              id: 'master', type: 'credit_card', installments: 1
            )
          )
        ]
      ),
      payer: Request::PayerRequest.new(
        email: 'buyer@example.com',
        identification: Request::IdentificationRequest.new(type: 'CPF', number: '12345678909')
      ),
      items: [
        Request::ItemRequest.new(title: 'Flight', quantity: 1, unit_price: '1000.00', type: 'travel')
      ]
    )

    sdk_hash, hc_hash = sdk_with_capture
    sdk_hash.order.create(order_hash)

    sdk_typed, hc_typed = sdk_with_capture
    sdk_typed.order.create(typed)

    assert_equal posted_json(hc_hash), posted_json(hc_typed)
  end

  # ---- E2E-3: typed AP flow (automatic_payments + stored_credential + subscription_data) ----

  def test_typed_automatic_payments_flow_snake_case
    sdk, http_client = sdk_with_capture

    typed = Request::CreateRequest.new(
      type: 'online',
      total_amount: '1000.00',
      transactions: Request::TransactionRequest.new(
        payments: [
          Request::PaymentRequest.new(
            amount: '1000.00',
            payment_method: Request::PaymentMethodRequest.new(id: 'master', type: 'credit_card'),
            automatic_payments: Request::AutomaticPaymentsRequest.new(
              payment_profile_id: 'PROFILE_1', schedule_date: '2026-08-01', due_date: '2026-08-05', retries: 3
            ),
            stored_credential: Request::StoredCredentialRequest.new(
              payment_initiator: 'merchant', reason: 'recurring',
              store_payment_method: true, first_payment: false, prev_transaction_ref: 'PREV_TX_1'
            ),
            subscription_data: Request::SubscriptionDataRequest.new(
              invoice_id: 'INV_1', billing_date: '2026-08-01',
              subscription_sequence: Request::SubscriptionSequenceRequest.new(number: 2, total: 12),
              invoice_period: Request::InvoicePeriodRequest.new(type: 'monthly', period: 1)
            )
          )
        ]
      ),
      integration_data: Request::IntegrationDataRequest.new(
        integrator_id: 'INTEG_1',
        sponsor: Request::SponsorRequest.new(id: 'SPONSOR_1')
      ),
      config: Request::ConfigRequest.new(
        online: {
          transaction_security: Request::TransactionSecurityRequest.new(
            validation: 'complete', liability_shift: 'issuer'
          ).to_hash
        }
      )
    )

    sdk.order.create(typed)
    payload = posted_json(http_client)
    payment = payload['transactions']['payments'][0]

    ap = payment['automatic_payments']
    assert_equal 'PROFILE_1', ap['payment_profile_id']
    assert_equal '2026-08-01', ap['schedule_date']
    assert_equal '2026-08-05', ap['due_date']
    assert_equal 3, ap['retries']

    sc = payment['stored_credential']
    assert_equal 'merchant', sc['payment_initiator']
    assert_equal 'recurring', sc['reason']
    assert_equal true, sc['store_payment_method']
    assert_equal false, sc['first_payment']
    assert_equal 'PREV_TX_1', sc['prev_transaction_ref']

    sub = payment['subscription_data']
    assert_equal 'INV_1', sub['invoice_id']
    assert_equal '2026-08-01', sub['billing_date']
    assert_equal({ 'number' => 2, 'total' => 12 }, sub['subscription_sequence'])
    assert_equal({ 'type' => 'monthly', 'period' => 1 }, sub['invoice_period'])

    integ = payload['integration_data']
    assert_equal 'INTEG_1', integ['integrator_id']
    assert_equal({ 'id' => 'SPONSOR_1' }, integ['sponsor'])

    ts = payload['config']['online']['transaction_security']
    assert_equal 'complete', ts['validation']
    assert_equal 'issuer', ts['liability_shift']
  end

  private

  def symbolize(obj)
    case obj
    when Hash
      obj.each_with_object({}) { |(k, v), acc| acc[k.to_sym] = symbolize(v) }
    when Array
      obj.map { |e| symbolize(e) }
    else
      obj
    end
  end
end

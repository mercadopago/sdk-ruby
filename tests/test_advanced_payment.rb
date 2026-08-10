# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestAdvancedPayment < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 111, 'status' => 'approved' } })
    result = @sdk.advanced_payment.get(111)
    assert_equal 200, result[:status]
    assert_equal 111, result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 222, 'status' => 'pending' } })
    result = @sdk.advanced_payment.create({
                                            payer: { type: 'customer', email: 'buyer@test.com' },
                                            payments: [{ payment_method_id: 'visa', token: 'tok_abc', transaction_amount: 100.0 }],
                                            disbursements: [{ collector_id: 456_789, amount: 100.0 }]
                                          })
    assert_equal 201, result[:status]
    assert_equal 222, result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_search
    mock_response({ status: 200, response: { 'paging' => { 'total' => 1 }, 'results' => [{ 'id' => 111 }] } })
    result = @sdk.advanced_payment.search(filters: { status: 'approved' })
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['paging']['total']
    assert_equal :get, @mock_http.last_call
  end

  def test_update
    mock_response({ status: 200, response: { 'id' => 111, 'status' => 'approved' } })
    result = @sdk.advanced_payment.update(111, { capture: true })
    assert_equal 200, result[:status]
    assert_equal 111, result[:response]['id']
    assert_equal :put, @mock_http.last_call
  end

  def test_capture
    mock_response({ status: 200, response: { 'id' => 111, 'capture' => true } })
    result = @sdk.advanced_payment.capture(111)
    assert_equal 200, result[:status]
    assert_equal true, result[:response]['capture']
    assert_equal :put, @mock_http.last_call
  end

  def test_cancel
    mock_response({ status: 200, response: { 'id' => 111, 'status' => 'cancelled' } })
    result = @sdk.advanced_payment.cancel(111)
    assert_equal 200, result[:status]
    assert_equal 'cancelled', result[:response]['status']
    assert_equal :put, @mock_http.last_call
  end

  def test_update_release_date
    mock_response({ status: 200, response: { 'id' => 111 } })
    release_date = Time.now + 86_400
    result = @sdk.advanced_payment.update_release_date(111, release_date)
    assert_equal 200, result[:status]
    assert_equal 111, result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end
end

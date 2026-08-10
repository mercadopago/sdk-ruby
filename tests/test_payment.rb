# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestPayment < BaseClientTest
  def test_search
    mock_response({ status: 200, response: { 'paging' => { 'total' => 1 }, 'results' => [{ 'id' => 123 }] } })
    result = @sdk.payment.search(filters: { id: 123 })
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['paging']['total']
    assert_equal :get, @mock_http.last_call
  end

  def test_get
    mock_response({ status: 200, response: { 'id' => 123, 'status' => 'approved' } })
    result = @sdk.payment.get(123)
    assert_equal 200, result[:status]
    assert_equal 123, result[:response]['id']
    assert_equal 'approved', result[:response]['status']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 456, 'status' => 'pending' } })
    result = @sdk.payment.create({ transaction_amount: 100.0, token: 'abc123', payment_method_id: 'visa',
                                   installments: 1, payer: { email: 'test@test.com' } })
    assert_equal 201, result[:status]
    assert_equal 456, result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_update
    mock_response({ status: 200, response: { 'id' => 123, 'status' => 'cancelled' } })
    result = @sdk.payment.update(123, { status: 'cancelled' })
    assert_equal 200, result[:status]
    assert_equal 123, result[:response]['id']
    assert_equal :put, @mock_http.last_call
  end

  def test_capture
    mock_response({ status: 200, response: { 'id' => 123, 'captured' => true } })
    result = @sdk.payment.capture(123)
    assert_equal 200, result[:status]
    assert_equal true, result[:response]['captured']
    assert_equal :put, @mock_http.last_call
  end

  def test_capture_with_amount
    mock_response({ status: 200, response: { 'id' => 123, 'transaction_amount' => 50.0, 'captured' => true } })
    result = @sdk.payment.capture(123, amount: 50.0)
    assert_equal 200, result[:status]
    assert_equal 50.0, result[:response]['transaction_amount']
    assert_equal :put, @mock_http.last_call
  end

  def test_search_auto_paging_iter_returns_iterator
    iterator = @sdk.payment.search_auto_paging_iter(filters: { status: 'approved' })
    assert_respond_to iterator, :each
  end
end

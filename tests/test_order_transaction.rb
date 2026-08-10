# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestOrderTransaction < BaseClientTest
  def test_create
    mock_response({ status: 201, response: { 'id' => 'TXN-001', 'status' => 'pending' } })
    result = @sdk.order_transaction.create('ORD-123', { payment: { type: 'credit_card', token: 'tok_abc' } })
    assert_equal 201, result[:status]
    assert_equal 'TXN-001', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_update
    mock_response({ status: 200, response: { 'id' => 'TXN-001', 'status' => 'processed' } })
    result = @sdk.order_transaction.update('ORD-123', 'TXN-001', { status: 'processed' })
    assert_equal 200, result[:status]
    assert_equal 'TXN-001', result[:response]['id']
    assert_equal :put, @mock_http.last_call
  end

  def test_delete
    mock_response({ status: 204, response: nil })
    result = @sdk.order_transaction.delete('ORD-123', 'TXN-001')
    assert_equal 204, result[:status]
    assert_equal :delete, @mock_http.last_call
  end
end

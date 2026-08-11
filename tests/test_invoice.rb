# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestInvoice < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 'INV-001', 'status' => 'processed', 'transaction_amount' => 100.0 } })
    result = @sdk.invoice.get('INV-001')
    assert_equal 200, result[:status]
    assert_equal 'INV-001', result[:response]['id']
    assert_equal 100.0, result[:response]['transaction_amount']
    assert_equal :get, @mock_http.last_call
  end

  def test_search
    mock_response({ status: 200, response: { 'paging' => { 'total' => 1 }, 'results' => [{ 'id' => 'INV-001' }] } })
    result = @sdk.invoice.search(filters: { preapproval_id: 'PA-123' })
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['paging']['total']
    assert_equal :get, @mock_http.last_call
  end
end

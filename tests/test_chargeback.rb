# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestChargeback < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 'CB-001', 'status' => 'opened' } })
    result = @sdk.chargeback.get('CB-001')
    assert_equal 200, result[:status]
    assert_equal 'CB-001', result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_search
    mock_response({ status: 200, response: { 'paging' => { 'total' => 1 }, 'results' => [{ 'id' => 'CB-001' }] } })
    result = @sdk.chargeback.search(filters: { payment_id: 123 })
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['paging']['total']
    assert_equal :get, @mock_http.last_call
  end
end

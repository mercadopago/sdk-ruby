# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestMerchantOrder < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 789, 'status' => 'opened' } })
    result = @sdk.merchant_order.get(789)
    assert_equal 200, result[:status]
    assert_equal 789, result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 999, 'status' => 'opened' } })
    result = @sdk.merchant_order.create({ preference_id: 'PREF-123', items: [] })
    assert_equal 201, result[:status]
    assert_equal 999, result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_update
    mock_response({ status: 200, response: { 'id' => 789, 'status' => 'closed' } })
    result = @sdk.merchant_order.update(789, { status: 'closed' })
    assert_equal 200, result[:status]
    assert_equal 'closed', result[:response]['status']
    assert_equal :put, @mock_http.last_call
  end

  def test_search
    mock_response({ status: 200, response: { 'total' => 1, 'elements' => [{ 'id' => 789 }] } })
    result = @sdk.merchant_order.search(filters: { preference_id: 'PREF-123' })
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['total']
    assert_equal :get, @mock_http.last_call
  end
end

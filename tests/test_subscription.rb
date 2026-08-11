# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestSubscription < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 'SUB-123', 'status' => 'authorized' } })
    result = @sdk.subscription.get('SUB-123')
    assert_equal 200, result[:status]
    assert_equal 'SUB-123', result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 'SUB-456', 'status' => 'pending' } })
    result = @sdk.subscription.create({ preapproval_plan_id: 'PLAN-001', payer_email: 'test@test.com',
                                        card_token_id: 'tok_abc' })
    assert_equal 201, result[:status]
    assert_equal 'SUB-456', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_update
    mock_response({ status: 200, response: { 'id' => 'SUB-123', 'status' => 'paused' } })
    result = @sdk.subscription.update('SUB-123', { status: 'paused' })
    assert_equal 200, result[:status]
    assert_equal 'paused', result[:response]['status']
    assert_equal :put, @mock_http.last_call
  end

  def test_search
    mock_response({ status: 200, response: { 'paging' => { 'total' => 1 }, 'results' => [{ 'id' => 'SUB-123' }] } })
    result = @sdk.subscription.search(filters: { status: 'authorized' })
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['paging']['total']
    assert_equal :get, @mock_http.last_call
  end
end

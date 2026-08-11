# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestPreapproval < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 'PA-123', 'status' => 'authorized' } })
    result = @sdk.preapproval.get('PA-123')
    assert_equal 200, result[:status]
    assert_equal 'PA-123', result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 'PA-456', 'status' => 'pending' } })
    result = @sdk.preapproval.create({ preapproval_plan_id: 'PLAN-001', payer_email: 'test@test.com',
                                       card_token_id: 'tok_abc' })
    assert_equal 201, result[:status]
    assert_equal 'PA-456', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_update
    mock_response({ status: 200, response: { 'id' => 'PA-123', 'status' => 'paused' } })
    result = @sdk.preapproval.update('PA-123', { status: 'paused' })
    assert_equal 200, result[:status]
    assert_equal 'paused', result[:response]['status']
    assert_equal :put, @mock_http.last_call
  end

  def test_search
    mock_response({ status: 200, response: { 'paging' => { 'total' => 1 }, 'results' => [{ 'id' => 'PA-123' }] } })
    result = @sdk.preapproval.search(filters: { status: 'authorized' })
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['paging']['total']
    assert_equal :get, @mock_http.last_call
  end

  def test_search_auto_paging_iter_returns_iterator
    iterator = @sdk.preapproval.search_auto_paging_iter(filters: { status: 'authorized' })
    assert_respond_to iterator, :each
  end
end

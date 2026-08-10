# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestPreapprovalPlan < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 'PLAN-001', 'status' => 'active' } })
    result = @sdk.preapproval_plan.get('PLAN-001')
    assert_equal 200, result[:status]
    assert_equal 'PLAN-001', result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 'PLAN-002', 'status' => 'active' } })
    result = @sdk.preapproval_plan.create({ reason: 'Monthly subscription', auto_recurring: { frequency: 1,
                                                                                               frequency_type: 'months', transaction_amount: 10.0, currency_id: 'BRL' } })
    assert_equal 201, result[:status]
    assert_equal 'PLAN-002', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_update
    mock_response({ status: 200, response: { 'id' => 'PLAN-001', 'status' => 'inactive' } })
    result = @sdk.preapproval_plan.update('PLAN-001', { status: 'inactive' })
    assert_equal 200, result[:status]
    assert_equal 'inactive', result[:response]['status']
    assert_equal :put, @mock_http.last_call
  end

  def test_search
    mock_response({ status: 200, response: { 'paging' => { 'total' => 1 }, 'results' => [{ 'id' => 'PLAN-001' }] } })
    result = @sdk.preapproval_plan.search(filters: { status: 'active' })
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['paging']['total']
    assert_equal :get, @mock_http.last_call
  end
end

# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestDisbursementRefund < BaseClientTest
  def test_list
    mock_response({ status: 200, response: [{ 'id' => 'DR-001' }, { 'id' => 'DR-002' }] })
    result = @sdk.disbursement_refund.list(111)
    assert_equal 200, result[:status]
    assert_equal 2, result[:response].size
    assert_equal :get, @mock_http.last_call
  end

  def test_create_all
    mock_response({ status: 201, response: [{ 'id' => 'DR-003', 'status' => 'approved' }] })
    result = @sdk.disbursement_refund.create_all(111)
    assert_equal 201, result[:status]
    assert_equal 1, result[:response].size
    assert_equal :post, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 'DR-004', 'amount' => 50.0, 'status' => 'approved' } })
    result = @sdk.disbursement_refund.create(111, 222, amount: 50.0)
    assert_equal 201, result[:status]
    assert_equal 'DR-004', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end
end

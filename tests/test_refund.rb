# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestRefund < BaseClientTest
  def test_list
    mock_response({ status: 200, response: [{ 'id' => 'REF-1' }, { 'id' => 'REF-2' }] })
    result = @sdk.refund.list(123)
    assert_equal 200, result[:status]
    assert_equal 2, result[:response].size
    assert_equal :get, @mock_http.last_call
  end

  def test_get
    mock_response({ status: 200, response: { 'id' => 'REF-1', 'status' => 'approved' } })
    result = @sdk.refund.get(123, 'REF-1')
    assert_equal 200, result[:status]
    assert_equal 'REF-1', result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 'REF-99', 'status' => 'approved' } })
    result = @sdk.refund.create(123)
    assert_equal 201, result[:status]
    assert_equal 'REF-99', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end
end

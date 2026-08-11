# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestPaymentMethods < BaseClientTest
  def test_get
    mock_response({ status: 200, response: [{ 'id' => 'visa', 'name' => 'Visa', 'payment_type_id' => 'credit_card' },
                                             { 'id' => 'master', 'name' => 'Mastercard', 'payment_type_id' => 'credit_card' }] })
    result = @sdk.payment_methods.get
    assert_equal 200, result[:status]
    assert_equal 2, result[:response].size
    assert_equal 'visa', result[:response].first['id']
    assert_equal :get, @mock_http.last_call
  end
end

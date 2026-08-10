# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestIdentificationType < BaseClientTest
  def test_get
    mock_response({ status: 200, response: [{ 'id' => 'CPF', 'name' => 'CPF', 'type' => 'number' }] })
    result = @sdk.identification_type.get
    assert_equal 200, result[:status]
    assert_equal 1, result[:response].size
    assert_equal 'CPF', result[:response].first['id']
    assert_equal :get, @mock_http.last_call
  end
end

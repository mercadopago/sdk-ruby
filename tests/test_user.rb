# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestUser < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 123_456_789, 'email' => 'seller@test.com', 'site_id' => 'MLB' } })
    result = @sdk.user.get
    assert_equal 200, result[:status]
    assert_equal 123_456_789, result[:response]['id']
    assert_equal 'seller@test.com', result[:response]['email']
    assert_equal :get, @mock_http.last_call
  end
end

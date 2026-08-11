# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestOAuth < BaseClientTest
  def test_get_authorization_url
    url = @sdk.oauth.get_authorization_url('MY_APP_ID', 'https://mysite.com/callback', 'random_state_123')
    assert_includes url, 'https://auth.mercadopago.com/authorization'
    assert_includes url, 'client_id=MY_APP_ID'
    assert_includes url, 'response_type=code'
    assert_includes url, 'state=random_state_123'
  end

  def test_create
    mock_response({ status: 200, response: { 'access_token' => 'APP_TOKEN_123', 'refresh_token' => 'REFRESH_456',
                                             'expires_in' => 15_552_000 } })
    result = @sdk.oauth.create({
                                 client_secret: 'MY_ACCESS_TOKEN',
                                 code: 'AUTH_CODE_ABC',
                                 redirect_uri: 'https://mysite.com/callback',
                                 grant_type: 'authorization_code'
                               })
    assert_equal 200, result[:status]
    assert_equal 'APP_TOKEN_123', result[:response]['access_token']
    assert_equal :post, @mock_http.last_call
  end

  def test_refresh
    mock_response({ status: 200, response: { 'access_token' => 'NEW_TOKEN_789', 'refresh_token' => 'NEW_REFRESH_012',
                                             'expires_in' => 15_552_000 } })
    result = @sdk.oauth.refresh({
                                  client_secret: 'MY_ACCESS_TOKEN',
                                  refresh_token: 'OLD_REFRESH_TOKEN',
                                  grant_type: 'refresh_token'
                                })
    assert_equal 200, result[:status]
    assert_equal 'NEW_TOKEN_789', result[:response]['access_token']
    assert_equal :post, @mock_http.last_call
  end
end

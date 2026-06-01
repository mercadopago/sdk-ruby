# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestOAuth < Minitest::Test
  def test_get_authorization_url_builds_correct_url
    sdk = Mercadopago::SDK.new('TEST_TOKEN')
    url = sdk.oauth.get_authorization_url('MY_APP_ID', 'https://example.com/callback', 'csrf_state')

    assert_includes url, 'https://auth.mercadopago.com/authorization'
    assert_includes url, 'client_id=MY_APP_ID'
    assert_includes url, 'response_type=code'
    assert_includes url, 'platform_id=mp'
    assert_includes url, 'state=csrf_state'
    assert_includes url, 'redirect_uri='
  end

  def test_create_raises_on_non_hash
    sdk = Mercadopago::SDK.new('TEST_TOKEN')
    assert_raises(TypeError) { sdk.oauth.create('not_a_hash') }
  end

  def test_refresh_raises_on_non_hash
    sdk = Mercadopago::SDK.new('TEST_TOKEN')
    assert_raises(TypeError) { sdk.oauth.refresh('not_a_hash') }
  end
end

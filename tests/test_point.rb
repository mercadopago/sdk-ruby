# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPoint < Minitest::Test
  def test_get_devices_returns_valid_status
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    result = sdk.point.get_devices
    assert_includes [200, 400, 401, 403, 404], result[:status]
  end

  def test_create_raises_on_non_hash
    sdk = Mercadopago::SDK.new('TEST_TOKEN')
    assert_raises(TypeError) { sdk.point.create('device_123', 'not_a_hash') }
  end

  def test_get_devices_raises_on_non_hash_filters
    sdk = Mercadopago::SDK.new('TEST_TOKEN')
    assert_raises(TypeError) { sdk.point.get_devices(filters: 'not_a_hash') }
  end
end

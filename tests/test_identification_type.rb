# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestIdentificationType < Minitest::Test
  def test_method_get
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    sdk.request_options = Mercadopago::RequestOptions.new(corporation_id: 'abc')
    result = sdk.identification_type.get

    assert_equal 200, result[:status]
  end
end

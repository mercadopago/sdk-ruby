# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPaymentMethods < Minitest::Test
  def test_method_get
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    result = sdk.payment_methods.get
    assert_equal 200, result[:status]
  end
end

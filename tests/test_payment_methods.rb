# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPaymentMethods < Minitest::Test
  def test_method_get
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')
    result = sdk.payment_methods.get
    assert_equal 200, result[:status]
  end
end

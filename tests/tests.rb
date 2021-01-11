# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPreference < Minitest::Test
  def test_method_get
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')
    result = sdk.preference.get

    assert_equal 200, result[:status]
  end

  def test_method_get_id
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')
    result = sdk.preference.get('537031659-d710347b-7746-4025-b72b-e5be918b91ca')

    assert_equal 200, result[:status]
  end

  def test_method_post
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')
    data = {
      "items": [
        {
          "title": 'Dummy Item',
          "description": 'Multicolor Item',
          "quantity": 1,
          "currency_id": '',
          "unit_price": 10.0
        }
      ]
    }
    result = sdk.preference.create(data)
    assert_equal 201, result[:status]
  end

  def test_method_put
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')
    data = {
      "items": [
        {
          "title": 'Camiseta Barcelona',
          "description": 'Camiseta Oficial Barcelona',
          "quantity": 1,
          "currency_id": '',
          "unit_price": 10.0
        }
      ]
    }
    result = sdk.preference.update('537031659-e4a79653-8638-490c-a4e5-c39f6f8d9874', data)
    assert_equal 200, result[:status]
  end
end

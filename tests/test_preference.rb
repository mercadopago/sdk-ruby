# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPreference < Minitest::Test
  def test_method_get_id
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    data = {
      items: [
        {
          title: 'Dummy Item',
          description: 'Multicolor Item',
          quantity: 1,
          currency_id: '',
          unit_price: 10.0
        }
      ]
    }
    preference = sdk.preference.create(data)
    result = sdk.preference.get(preference[:response]['id'])
    assert_equal 200, result[:status]
  end

  def test_method_post
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    data = {
      items: [
        {
          title: 'Dummy Item',
          description: 'Multicolor Item',
          quantity: 1,
          currency_id: '',
          unit_price: 10.0
        }
      ]
    }
    result = sdk.preference.create(data)
    assert_equal 201, result[:status]
  end

  def test_method_put
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    data = {
      items: [
        {
          title: 'Dummy Item',
          description: 'Multicolor Item',
          quantity: 1,
          currency_id: '',
          unit_price: 10.0
        }
      ]
    }
    preference = sdk.preference.create(data)

    preferenceUpdate = {
      items: [
        {
          title: 'Camiseta Barcelona',
          description: 'Camiseta Oficial Barcelona',
          quantity: 2,
          unit_price: 10.0
        }
      ]
    }
    result = sdk.preference.update(preference[:response]['id'], preferenceUpdate)
    assert_equal 200, result[:status]
  end
end

# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class CardToken < Minitest::Test
  def test_method_get_id
    sdk = Mercadopago::SDK.new(access_token = 'APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966')
    card_token_object = {
      "card_number": '4235647728025682',
      "expiration_year": 2025,
      "expiration_month": 11,
      "security_code": '123',
      "cardholder": {
        "name": 'APRO'

      }
    }
    result_card_token = sdk.card_token.create(card_token_object)
    result = sdk.card_token.get(result_card_token[:response]['id'])
    assert_equal 200, result[:status]
  end

  def test_method_post
    sdk = Mercadopago::SDK.new('APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966')
    card_token_object = {
      "card_number": '4235647728025682',
      "expiration_year": 2025,
      "expiration_month": 11,
      "security_code": '123',
      "cardholder": {
        "name": 'APRO'
      }
    }
    result = sdk.card_token.create(card_token_object)
    assert_equal 201, result[:status]
  end
end

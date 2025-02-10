# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class CardToken < Minitest::Test
  def test_method_get_id
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    card_token_object = {
      card_number: '5031433215406351',
      expiration_year: 2030,
      expiration_month: 11,
      security_code: '123',
      cardholder: {
        name: 'APRO'
      }
    }
    result_card_token = sdk.card_token.create(card_token_object)
    result = sdk.card_token.get(result_card_token[:response]['id'])
    assert_equal 200, result[:status]
  end

  def test_method_post
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    card_token_object = {
      card_number: '5031433215406351',
      expiration_year: 2030,
      expiration_month: 11,
      security_code: '123',
      cardholder: {
        name: 'APRO'
      }
    }
    result = sdk.card_token.create(card_token_object)
    assert_equal 201, result[:status]
  end
end

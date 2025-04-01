# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'
require 'minitest/autorun'

##
# TestRefund
class TestRefund < Minitest::Test
  def test_refund_post_and_list
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
    payment_object = {
      transaction_amount: 110,
      installments: 1,
      capture: true,
      description: 'Payment test',
      payment_method_id: 'master',
      token: result_card_token[:response]['id'],
      payer: {
        email: 'test_user_246340119@testuser.com'
      }
    }
    result_payment = sdk.payment.create(payment_object)
    sleep(1)

    result_refund = sdk.refund.create(result_payment[:response]['id'])
    assert_equal 201, result_refund[:status]
    assert_equal 'approved', result_refund[:response]['status']

    sleep(1)
    result_list = sdk.refund.list(result_refund[:response]['payment_id'])
    assert_equal 200, result_list[:status]
  end
end

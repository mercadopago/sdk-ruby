# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'
require 'minitest/autorun'
require 'securerandom'

##
# TestRefundCustom
class TestRefundCustom < Minitest::Test
  def test_method_post_with_custom_headers
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
    sleep(1)

    payment_object = {
      transaction_amount: 20,
      installments: 1,
      capture: true,
      description: 'Payment test',
      payment_method_id: 'master',
      token: result_card_token[:response]['id'],
      payer: {
        email: 'test_user_24634099@testuser.com'
      }
    }
    payment = sdk.payment.create(payment_object)
    sleep(1)
    payment_id = payment[:response]['id']
    refund_data = {
      'amount': 2
    }
    uuid = SecureRandom.uuid
    custom_headers = {
      'x-idempotency-key': uuid
    }
    custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)
    # calling a request with an existing 'x-idempotency-key', the API should return 200,
    # instead of create other refund
    result_refund_custom = sdk.refund.create(payment_id, refund_data: refund_data, request_options: custom_request_options)
    assert_equal 201, result_refund_custom[:status]
    assert_equal 'approved', result_refund_custom[:response]['status']
  end
end

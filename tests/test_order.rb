# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestOrder < Minitest::Test

  def test_create_order
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    order_request = create_order_request
    result = sdk.order.create(order_request)
    assert_equal 201, result[:status]
  end

  def test_get_order
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    order_request = create_order_request
    result = sdk.order.create(order_request)
    assert_equal 201, result[:status]
    order_created = result[:response]

    result_get = sdk.order.get(order_created['id'])
    order = result_get[:response]

    assert_equal 200, result_get[:status]
    assert_equal order_created['id'], order['id']
  end

  def test_process_order
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    card_token_object = {
      card_number: '5031433215406351',
      expiration_year: 2025,
      expiration_month: 11,
      security_code: '123',
      cardholder: {
        name: 'APRO'
      }
    }
    result_card_token = sdk.card_token.create(card_token_object)
    order_request = {
      type: 'online',
      processing_mode: 'manual',
      total_amount: '1000.00',
      external_reference: 'ext_ref_1234',
      transactions: {
        payments: [
          {
            amount: '1000.00',
            payment_method: {
              id: 'master',
              type: 'credit_card',
              token: result_card_token[:response]['id'],
              installments: 1
            }
          }
        ]
      },
      payer: {
        email: 'test_1731350184@testuser.com'
      }
    }
    result_created = sdk.order.create(order_request)
    order_created = result_created[:response]

    result_process = sdk.order.process(order_created['id'])
    order_process = result_process[:response]
    assert_equal 200, result_process[:status]
    assert_equal order_process['status'], 'processed'
  end

  def create_order_request
    {
      type: 'online',
      total_amount: '1000.00',
      external_reference: 'ext_ref_1234',
      transactions: {
        payments: [
          {
            amount: '1000.00',
            payment_method: {
              id: 'pix',
              type: 'bank_transfer'
            }
          }
        ]
      },
      payer: {
        email: 'test_1731350184@testuser.com'
      }
    }
  end

end

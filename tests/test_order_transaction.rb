# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestOrder < Minitest::Test

  def test_create_transaction
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    order_request = create_order_request
    order_transaction_data = {
      payments: [{
        amount: '10.00',
        payment_method: {
          id: 'pix',
          type: 'bank_transfer'
        }
      }]
    }

    result = sdk.order.create(order_request)
    order_created = result[:response]
    assert_equal 201, result[:status]

    result_transaction = sdk.order_transaction.create(order_created['id'], order_transaction_data)
    assert_equal 201, result_transaction[:status]
  end

  def test_update_transaction
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
    assert_equal 201, result_created[:status]

    transaction_update_request = {
      payment_method: {
        installments: 5
      }
    }
    transaction_id = order_created['transactions']['payments'][0]['id']

    result_transaction = sdk.order_transaction.update(order_created['id'], transaction_id, transaction_update_request)
    assert_equal 200, result_transaction[:status]
    assert_equal 5, result_transaction[:response]['payment_method']['installments']
  end

  def test_delete_transaction
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
    assert_equal 201, result_created[:status]

    transaction_id = order_created['transactions']['payments'][0]['id']

    result_transaction = sdk.order_transaction.delete(order_created['id'], transaction_id)
    assert_equal 204, result_transaction[:status]
  end

  def create_order_request
    {
      type: 'online',
      processing_mode: 'manual',
      total_amount: '1000.00',
      external_reference: 'ext_ref_1234',
      payer: {
        email: 'test_1731350184@testuser.com'
      }
    }
  end

end

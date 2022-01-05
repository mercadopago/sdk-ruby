# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'
require 'minitest/autorun'
require 'securerandom'

##
# TestRefund
class TestRefund < Minitest::Test
  def test_method_post_with_custom_headers
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')
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

    payment_object = {
      token: result_card_token[:response]['id'],
      installments: 1,
      transaction_amount: 10,
      description: 'Point Mini a maquininha que dá o dinheiro de suas vendas na hora',
      payment_method_id: 'master',
      payer: {
        email: 'test_user_123456@testuser.com',
        identification: {
          number: '19119119100',
          type: 'CPF'
        }
      },
      notification_url: 'https://www.suaurl.com/notificacoes/',
      binary_mode: false,
      external_reference: 'MP0001',
      statement_descriptor: 'MercadoPago',
      additional_info: {
        items: [
          {
            id: 'PR0001',
            title: 'Point Mini',
            description: 'Producto Point para cobros con tarjetas mediante bluetooth',
            picture_url: 'https://http2.mlstatic.com/resources/frontend/statics/growth-sellers-landings/device-mlb-point-i_medium@2x.png',
            category_id: 'electronics',
            quantity: 1,
            unit_price: 58.80
          }
        ],
        payer: {
          first_name: 'Nome',
          last_name: 'Sobrenome',
          address: {
            zip_code: '06233-200',
            street_name: 'Av das Nacoes Unidas',
            street_number: 3003
          },
          registration_date: '2019-01-01T12:01:01.000-03:00',
          phone: {
            area_code: '011',
            number: '987654321'
          }
        },
        shipments: {
          receiver_address: {
            street_name: 'Av das Nacoes Unidas',
            street_number: 3003,
            zip_code: '06233200',
            city_name: 'Buzios',
            state_name: 'Rio de Janeiro'
          }
        }
      }
    }
    result_payment = sdk.payment.create(payment_object)
    payment_id = result_payment[:response]['id']
    refund_data = {
      'amount': 2.95
    }
    uuid = SecureRandom.uuid
    custom_headers = {
      'x-idempotency-key': uuid
    }
    custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)
    result = sdk.refund.create(payment_id, refund_data: refund_data, request_options: custom_request_options)
    assert_equal 201, result[:status]
    assert_equal 'approved', result[:response]['status']

    # calling a request with an existing 'x-idempotency-key', the API should return 200,
    # instead of create other refund
    result = sdk.refund.create(payment_id, refund_data: refund_data, request_options: custom_request_options) 
    assert_equal 200, result[:status]
  end
end

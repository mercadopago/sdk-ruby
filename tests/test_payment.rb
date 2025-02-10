# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPayment < Minitest::Test
  def test_method_search
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
      token: result_card_token[:response]['id'],
      installments: 1,
      transaction_amount: 58.80,
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
    payment = sdk.payment.create(payment_object)

    result = sdk.payment.search(filters: { id: payment[:response]['id'] })
   
    assert_equal 1, result[:response]['paging']['total']
    assert_equal 200, result[:status]
  end

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

    payment_object = {
      token: result_card_token[:response]['id'],
      installments: 1,
      transaction_amount: 58.80,
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
    payment = sdk.payment.create(payment_object)
    result = sdk.payment.get(payment[:response]['id'])
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
    result_card_token = sdk.card_token.create(card_token_object)

    payment_object = {
      token: result_card_token[:response]['id'],
      installments: 1,
      transaction_amount: 58.80,
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
    result = sdk.payment.create(payment_object)
    assert_equal 201, result[:status]
  end

  def test_method_put
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    data = {
      status: 'approved'
    }
    result = sdk.payment.update(1_231_910_402, data)
    assert_equal 403, result[:status]
  end
end

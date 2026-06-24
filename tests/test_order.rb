# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestOrder < Minitest::Test
  class CaptureHttpClient < Mercadopago::HttpClient
    attr_reader :last_post

    def post(url:, data:, headers:, timeout: nil)
      @last_post = {
        url: url,
        data: data,
        headers: headers,
        timeout: timeout
      }

      {
        status: 201,
        response: {
          'id' => 'ORD123',
          'type' => 'online',
          'processing_mode' => 'manual',
          'checkout_url' => 'https://www.mercadopago.com/checkout/v1/redirect?order_id=ORD123'
        }
      }
    end
  end

  def test_create_checkout_pro_order
    http_client = CaptureHttpClient.new
    sdk = Mercadopago::SDK.new('ACCESS_TOKEN', http_client: http_client)
    request_options = Mercadopago::RequestOptions.new(
      custom_headers: { 'X-Idempotency-Key': 'checkout-pro-key' }
    )
    order_request = create_checkout_pro_order_request.merge(
      type: 'wrong',
      processing_mode: 'automatic'
    )

    result = sdk.order.create_checkout_pro(order_request, request_options: request_options)
    payload = JSON.parse(http_client.last_post[:data])

    assert_equal 201, result[:status]
    assert_equal 'https://api.mercadopago.com/v1/orders', http_client.last_post[:url]
    assert_equal 'online', payload['type']
    assert_equal 'manual', payload['processing_mode']
    assert_equal '500.00', payload['total_amount']
    assert_equal 'https://example.com/success', payload['config']['online']['success_url']
    assert_equal ['ticket'], payload['config']['payment_method']['not_allowed_types']
    assert_equal 'checkout-pro-key', http_client.last_post[:headers]['X-Idempotency-Key']
    assert_equal 'https://www.mercadopago.com/checkout/v1/redirect?order_id=ORD123',
                 result[:response]['checkout_url']
  end

  def test_create_checkout_pro_order_requires_hash
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'] || 'ACCESS_TOKEN')

    assert_raises(TypeError) do
      sdk.order.create_checkout_pro('invalid')
    end
  end

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

    result_process = sdk.order.process(order_created['id'])
    order_process = result_process[:response]
    assert_equal 200, result_process[:status]
    assert_equal order_process['status'], 'processed'
  end

  def test_refund_total_order
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    result_card_token = sdk.card_token.create(create_card_token_request)
    order_request = {
      type: 'online',
      processing_mode: 'automatic',
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

    sleep(1)
    result_process = sdk.order.refund(order_created['id'])
    order_refunded = result_process[:response]
    assert_equal 201, result_process[:status]
    assert_equal order_refunded['status'], 'refunded'
  end

  def test_refund_partial_order
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    result_card_token = sdk.card_token.create(create_card_token_request)
    order_request = {
      type: 'online',
      processing_mode: 'automatic',
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

    refund_request = {
      transactions: [
        id: order_created['transactions']['payments'][0]['id'],
        amount: '25.00'
      ]
    }

    sleep(1)
    result_process = sdk.order.refund(order_created['id'], refund_data: refund_request)
    order_refunded = result_process[:response]
    assert_equal 201, result_process[:status]
    assert_equal order_refunded['status'], 'processed'
    assert_equal order_refunded['status_detail'], 'partially_refunded'
  end

  def test_cancel_order
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    card_token_object = create_card_token_request
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

    result_cancel = sdk.order.cancel(order_created['id'])
    order_cancel = result_cancel[:response]
    assert_equal 200, result_cancel[:status]
    assert_equal order_cancel['status'], 'canceled'
  end

  def test_capture_order
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
      processing_mode: 'automatic',
      capture_mode: 'manual',
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

    result_capture = sdk.order.capture(order_created['id'])
    order_capture = result_capture[:response]
    assert_equal 200, result_capture[:status]
    assert_equal order_created['id'], order_capture['id']
    assert_equal order_capture['status'], 'processed'
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

  def create_checkout_pro_order_request
    {
      total_amount: '500.00',
      external_reference: 'ext_ref_checkout_pro',
      capture_mode: 'automatic',
      marketplace_fee: '5.00',
      description: 'Travel package SAO-RIO with insurance',
      expiration_time: 'P1D',
      payer: {
        email: 'buyer@mercadopago.com',
        first_name: 'John',
        last_name: 'Smith',
        phone: {
          area_code: '11',
          number: '999998888'
        },
        identification: {
          type: 'CPF',
          number: '12345678909'
        }
      },
      shipment: {
        mode: 'custom',
        local_pickup: false,
        cost: '15.00',
        free_shipping: false,
        address: {
          zip_code: '01310-100',
          street_name: 'Av. Paulista',
          street_number: '1000',
          neighborhood: 'Bela Vista',
          city: 'Sao Paulo'
        }
      },
      config: {
        statement_descriptor: 'MYSTORE',
        online: {
          success_url: 'https://example.com/success',
          failure_url: 'https://example.com/failure',
          pending_url: 'https://example.com/pending',
          auto_return: 'approved',
          tracks: [
            {
              type: 'google_ad',
              values: {
                conversion_id: '21312312312123',
                conversion_label: 'TEST'
              }
            }
          ]
        },
        payment_method: {
          max_installments: 12,
          not_allowed_ids: ['amex'],
          not_allowed_types: ['ticket'],
          installments: {
            interest_free: {
              type: 'range',
              values: [2, 6]
            }
          }
        }
      },
      items: [
        {
          external_code: 'ITEM-001',
          title: 'Flight SAO-RIO',
          description: 'Round trip, economy class',
          category_id: 'travels',
          quantity: 1,
          unit_price: '450.00',
          type: 'travel'
        },
        {
          external_code: 'ITEM-002',
          title: 'Travel insurance',
          quantity: 1,
          unit_price: '50.00',
          type: 'travel'
        }
      ]
    }
  end

  def create_card_token_request
    {
      card_number: '5031433215406351',
      expiration_year: 2030,
      expiration_month: 11,
      security_code: '123',
      cardholder: {
        name: 'APRO'
      }
    }
  end

end

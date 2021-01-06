# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestMerchantOrden < Minitest::Test
  def test_method_search
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')
    result = sdk.merchant_orden.search({ 'id' => 123_187_219_6 })
    assert_equal 200, result[:status]
  end

  def test_method_post
    sdk = Mercadopago::SDK.new('APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966')
    data = {
      "items": [
        {
          "title": 'Dummy Item',
          "description": 'Multicolor Item',
          "quantity": 1,
          "currency_id": '',
          "unit_price": 10.0
        }
      ]
    }
    result_prefence = sdk.preference.create(data)
    merchant_orden_object = {
      "preference_id": result_prefence[:response]['id'],
      "site_id": 'MLB',
      "notification_url": 'https://seller/notification',
      "additional_info": 'Aditional info',
      "external_reference": 1,
      "marketplace": 'NONE',
      "items": [{
        "description": 'Test Update Success',
        "id": '5678',
        "picture_url": 'http://product1.image.png',
        "quantity": 1,
        "title": 'Item 1',
        "currency_id": 'BRL',
        "unit_price": 20.5
      }]
    }
    result_merchant_order = sdk.merchant_orden.create(merchant_orden_object)
    assert_equal 201, result_merchant_order[:status]
  end

  def test_method_get_id
    sdk = Mercadopago::SDK.new('APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966')
    result = sdk.merchant_orden.get('2112122225')
    assert_equal 200, result[:status]
  end

  def test_method_put
    sdk = Mercadopago::SDK.new('APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966')
    data = {
      "items": [
        {
          "title": 'Dummy Item',
          "description": 'Multicolor Item',
          "quantity": 1,
          "currency_id": '',
          "unit_price": 10.0
        }
      ]
    }
    result_prefence = sdk.preference.create(data)
    merchant_orden_object = {
      "preference_id": result_prefence[:response]['id'],
      "site_id": 'MLB',
      "notification_url": 'https://seller/notification',
      "additional_info": 'Aditional info',
      "external_reference": 1,
      "marketplace": 'NONE',
      "items": [
        {
          "description": 'Test Update Success',
          "id": '5678',
          "picture_url": 'http://product1.image.png',
          "quantity": 1,
          "title": 'Item 1',
          "currency_id": 'BRL',
          "unit_price": 20.5
        }
      ]
    }
    result_merchant_order = sdk.merchant_orden.create(merchant_orden_object)
    merchant_order_update = { "additional_info": 'Info 3' }
    result = sdk.merchant_orden.update(result_merchant_order[:response]['id'], merchant_order_update)
    assert_equal 200, result[:status]
  end
end

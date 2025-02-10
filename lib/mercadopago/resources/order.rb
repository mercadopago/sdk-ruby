# typed: true
# frozen_string_literal: true

module Mercadopago
  ###
  # This class provides the methods to access the API that will allow you to create an order on your website

  # From basic to advanced configurations, you control the whole experience.

  # [Click here for more infos](https://www.mercadopago.com/developers/en/docs/checkout-api/landing)

  class Order < MPBase
    def create(order_data, request_options: nil)
      raise TypeError, 'Param order_data must be a Hash' unless order_data.is_a?(Hash)

      _post(uri: '/v1/orders', data: order_data, request_options: request_options)
    end

    def get(order_id, request_options: nil)
      _get(uri: "/v1/orders/#{order_id}", request_options: request_options)
    end

    def process(order_id, request_options: nil)
      _post(uri: "/v1/orders/#{order_id}/process", data: nil,request_options: request_options)
    end

    def refund(order_id, refund_data: nil, request_options: nil)
      unless refund_data.nil?
        raise TypeError, 'Param refund_data must be a Hash' unless refund_data.is_a?(Hash)
      end

      _post(uri: "/v1/orders/#{order_id}/refund", data: refund_data, request_options: request_options)
    end

    def cancel(order_id, request_options: nil)
      _post(uri: "/v1/orders/#{order_id}/cancel", data: nil, request_options: request_options)
    end

    def capture(order_id, request_options: nil)
      _post(uri: "/v1/orders/#{order_id}/capture", data: nil, request_options: request_options)
    end

  end
end

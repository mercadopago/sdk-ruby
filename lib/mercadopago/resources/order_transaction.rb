
# typed: true
# frozen_string_literal: true

module Mercadopago
  ###
  # This class provides the methods to access the API that will allow you to create an order transaction on your website

  # From basic to advanced configurations, you control the whole experience.

  # [Click here for more infos](https://www.mercadopago.com/developers/en/docs/checkout-api/landing)

  class OrderTransaction < MPBase
    def create(order_id, order_transaction_data, request_options: nil)
      raise TypeError, 'Param order_transaction_data must be a Hash' unless order_transaction_data.is_a?(Hash)

      _post(uri: "/v1/orders/#{order_id}/transactions", data: order_transaction_data, request_options: request_options)
    end

    def update(order_id, transaction_id, order_transaction_data, request_options: nil)
      raise TypeError, 'Param order_transaction_data must be a Hash' unless order_transaction_data.is_a?(Hash)

      _put(uri: "/v1/orders/#{order_id}/transactions/#{transaction_id}", data: order_transaction_data, request_options: request_options)
    end

    def delete(order_id, transaction_id, request_options: nil)
      _delete(uri: "/v1/orders/#{order_id}/transactions/#{transaction_id}", request_options: request_options)
    end

  end
end

# typed: true
# frozen_string_literal: true

module Mercadopago
  ###
  # This class will allow you to create and manage your orders. You can attach one or more payments in your merchant order.

  class MerchantOrden < MPBase
    def search(filters = nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.is_a?(Hash)

      _get(uri: '/merchant_orders/search', filters: filters, request_options: request_options)
    end

    def get(merchant_orders_id, request_options: nil)
      _get(uri: "/merchant_orders/#{merchant_orders_id}", request_options: request_options)
    end

    def create(merchant_orders_object, request_options: nil)
      raise TypeError, 'Param merchant_orders_object must be a Hash' unless merchant_orders_object.is_a?(Hash)

      _post(uri: '/merchant_orders', data: merchant_orders_object, request_options: request_options)
    end

    def update(merchant_orders_id, merchant_orders_object, request_options: nil)
      raise TypeError, 'Param merchant_orders_object must be a Hash' unless merchant_orders_object.is_a?(Hash)

      _put(uri: "/merchant_orders/#{merchant_orders_id}", data: merchant_orders_object,
           request_options: request_options)
    end
  end
end

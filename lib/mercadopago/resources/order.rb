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
  end
end

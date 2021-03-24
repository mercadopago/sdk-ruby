# typed: true
# frozen_string_literal: true

module Mercadopago
  ###
  # This class allows you to store customers data safely to improve the shopping experience.

  # This will allow your customer to complete their purchases much faster and easily when used in conjunction with the Cards class.
  # [Click here for more infos](https://mercadopago.com.br/developers/en/guides/online-payments/web-tokenize-checkout/customers-and-cards)

  class Customer < MPBase
    def search(filters: nil, request_options: nil)
      _get(uri: '/v1/customers/search', filters: filters, request_options: request_options)
    end

    def get(customer_id, request_options: nil)
      _get(uri: "/v1/customers/#{customer_id}", request_options: request_options)
    end

    def create(customer_data, request_options: nil)
      raise TypeError, 'Param customer_data must be a Hash' unless customer_data.is_a?(Hash)

      _post(uri: '/v1/customers', data: customer_data, request_options: request_options)
    end

    def update(customer_id, customer_data, request_options: nil)
      raise TypeError, 'Param customer_data must be a Hash' unless customer_data.is_a?(Hash)

      _put(uri: "/v1/customers/#{customer_id}", data: customer_data, request_options: request_options)
    end

    def delete(customer_id, request_options: nil)
      _delete(uri: "/v1/customers/#{customer_id}", request_options: request_options)
    end
  end
end

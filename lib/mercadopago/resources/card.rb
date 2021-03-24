# typed: true
# frozen_string_literal: true

module Mercadopago
  ###
  # The cards class is the way to store card data of your customers safely to improve the shopping experience.
  # This will allow your customers to complete their purchases much faster and easily, since they will not have to complete their card data again.

  # This class must be used in conjunction with the Customer class.
  # [Click here for more infos](https://www.mercadopago.com/developers/en/guides/online-payments/web-tokenize-checkout/customers-and-cards)

  class Card < MPBase
    def get(customer_id, card_id, request_options: nil)
      _get(uri: "/v1/customers/#{customer_id}/cards/#{card_id}", request_options: request_options)
    end

    def create(customer_id, card_data, request_options: nil)
      raise TypeError, 'Param card_data must be a Hash' if card_data.nil? || !card_data.is_a?(Hash)

      _post(uri: "/v1/customers/#{customer_id}/cards/", data: card_data, request_options: request_options)
    end

    def delete(customer_id, card_id, request_options: nil)
      _delete(uri: "/v1/customers/#{customer_id}/cards/#{card_id}", request_options: request_options)
    end

    def list(customer_id, request_options: nil)
      _get(uri: "/v1/customers/#{customer_id}/cards", request_options: request_options)
    end
  end
end

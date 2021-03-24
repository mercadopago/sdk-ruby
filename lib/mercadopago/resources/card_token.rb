# typed: true
# frozen_string_literal: true

module Mercadopago
  ##
  # This class will allow you to send your customers card data for Mercado Pago server and receive a token to complete the payments transactions.

  class CardToken < MPBase
    def get(card_token_id, request_options: nil)
      _get(uri: "/v1/card_tokens/#{card_token_id}", request_options: request_options)
    end

    def create(card_token_data, request_options: nil)
      raise TypeError, 'Param card_token_data must be a Hash' unless card_token_data.is_a?(Hash)

      _post(uri: '/v1/card_tokens', data: card_token_data, request_options: request_options)
    end
  end
end

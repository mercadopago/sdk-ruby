# typed: true
# frozen_string_literal: true

module Mercadopago
  # Tokenises raw card data on the MercadoPago server.
  #
  # The returned token is a single-use reference that replaces
  # sensitive card details when creating a payment or saving a card
  # to a {Customer}. This keeps PCI-sensitive data off your servers.
  #
  # @see https://www.mercadopago.com/developers/en/reference
  class CardToken < MPBase
    # Retrieves an existing card token's metadata.
    #
    # @param card_token_id [String] token ID returned by {#create}
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with token details
    def get(card_token_id, request_options: nil)
      _get(uri: "/v1/card_tokens/#{_path_param(card_token_id)}", request_options: request_options)
    end

    # Creates a new card token from raw card data.
    #
    # @param card_token_data [Hash] card details (card_number, expiration_month, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the generated token
    # @raise [TypeError] if +card_token_data+ is not a Hash
    def create(card_token_data, request_options: nil)
      raise TypeError, 'Param card_token_data must be a Hash' unless card_token_data.is_a?(Hash)

      _post(uri: '/v1/card_tokens', data: card_token_data, request_options: request_options)
    end
  end
end

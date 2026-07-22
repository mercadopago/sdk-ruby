# typed: true
# frozen_string_literal: true

module Mercadopago
  # Manages saved cards linked to a {Customer}.
  #
  # Stored cards enable one-click purchases by allowing customers
  # to re-use previously tokenised card data. A card is always
  # associated with a customer ID.
  #
  # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api/cards/save-card/post
  class Card < MPBase
    # Retrieves a specific card saved for a customer.
    #
    # @param customer_id [String] MercadoPago customer ID
    # @param card_id [String] saved card ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with card details
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api/cards/get-card/get
    def get(customer_id, card_id, request_options: nil)
      _get(uri: "/v1/customers/#{_path_param(customer_id)}/cards/#{_path_param(card_id)}", request_options: request_options)
    end

    # Saves a new card for a customer using a previously generated card token.
    #
    # @param customer_id [String] MercadoPago customer ID
    # @param card_data [Hash] card attributes (must include +token+ from {CardToken})
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created card
    # @raise [TypeError] if +card_data+ is nil or not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api/cards/save-card/post
    def create(customer_id, card_data, request_options: nil)
      raise TypeError, 'Param card_data must be a Hash' if card_data.nil? || !card_data.is_a?(Hash)

      _post(uri: "/v1/customers/#{_path_param(customer_id)}/cards/", data: card_data, request_options: request_options)
    end

    # Deletes a saved card from a customer.
    #
    # @param customer_id [String] MercadoPago customer ID
    # @param card_id [String] saved card ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api/cards/delete-card/delete
    def delete(customer_id, card_id, request_options: nil)
      _delete(uri: "/v1/customers/#{_path_param(customer_id)}/cards/#{_path_param(card_id)}", request_options: request_options)
    end

    # Lists all saved cards for a customer.
    #
    # @param customer_id [String] MercadoPago customer ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with an array of cards
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api/cards/get-customer-cards/get
    def list(customer_id, request_options: nil)
      _get(uri: "/v1/customers/#{_path_param(customer_id)}/cards", request_options: request_options)
    end
  end
end

# typed: true
# frozen_string_literal: true

module Mercadopago
  # Manages payment operations through the Checkout API.
  #
  # Supports the full payment lifecycle: create, retrieve, search, and
  # update. Use this resource to build custom checkout experiences.
  #
  # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api-payments/create-payment/post
  class Payment < MPBase
    # Searches payments matching the given filters.
    #
    # @param filters [Hash, nil] query parameters (e.g. +{ status: "approved", external_reference: "ref" }+)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with search results
    # @raise [TypeError] if +filters+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api-payments/search-payments/get
    def search(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/v1/payments/search', filters: filters, request_options: request_options)
    end

    # Retrieves a single payment by its ID.
    #
    # @param payment_id [Integer, String] MercadoPago payment ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with payment details
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api-payments/get-payment/get
    def get(payment_id, request_options: nil)
      _get(uri: "/v1/payments/#{payment_id}", request_options: request_options)
    end

    # Creates a new payment.
    #
    # @param payment_data [Hash] payment attributes (amount, payer, payment_method, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created payment
    # @raise [TypeError] if +payment_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api-payments/create-payment/post
    def create(payment_data, request_options: nil)
      raise TypeError, 'Param payment_data must be a Hash' unless payment_data.is_a?(Hash)

      _post(uri: '/v1/payments/', data: payment_data, request_options: request_options)
    end

    # Updates an existing payment (e.g. capture an authorized payment).
    #
    # @param payment_id [Integer, String] MercadoPago payment ID
    # @param payment_data [Hash] fields to update
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the updated payment
    # @raise [TypeError] if +payment_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api-payments/update-payment/put
    def update(payment_id, payment_data, request_options: nil)
      raise TypeError, 'Param payment_data must be a Hash' unless payment_data.is_a?(Hash)

      _put(uri: "/v1/payments/#{payment_id}", data: payment_data, request_options: request_options)
    end
  end
end

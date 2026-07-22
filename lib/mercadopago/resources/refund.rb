# typed: true
# frozen_string_literal: true

module Mercadopago
  # Issues full or partial refunds on approved payments.
  #
  # Refunds can be created within 180 days of payment approval.
  # The seller's account must hold enough funds to cover the refund;
  # otherwise the API returns a 400 Bad Request.
  #
  # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api-payments/create-refund/post
  class Refund < MPBase
    # Lists all refunds for a given payment.
    #
    # @param payment_id [Integer, String] MercadoPago payment ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with an array of refunds
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api-payments/get-refunds/get
    def list(payment_id, request_options: nil)
      _get(uri: "/v1/payments/#{_path_param(payment_id)}/refunds", request_options: request_options)
    end

    # Creates a full or partial refund on a payment.
    #
    # Omit +refund_data+ for a full refund, or pass +{ amount: 10.0 }+
    # for a partial refund.
    #
    # @param payment_id [Integer, String] MercadoPago payment ID
    # @param refund_data [Hash, nil] optional refund attributes (e.g. +{ amount: 10.0 }+)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created refund
    # @raise [TypeError] if +refund_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api-payments/create-refund/post
    def create(payment_id, refund_data: nil, request_options: nil)
      raise TypeError, 'Param refund_data must be a Hash' unless refund_data.nil? || refund_data.is_a?(Hash)

      _post(uri: "/v1/payments/#{_path_param(payment_id)}/refunds", data: refund_data, request_options: request_options)
    end
  end
end

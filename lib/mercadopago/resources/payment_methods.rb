# typed: true
# frozen_string_literal: true

module Mercadopago
  # Lists the payment methods available for the caller's MercadoPago site
  # (credit cards, debit cards, bank transfer, cash, etc.).
  #
  # Useful for building dynamic checkout forms that only show the methods
  # the buyer can actually use.
  #
  # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api/payment-methods/get
  class PaymentMethods < MPBase
    # Retrieves all payment methods available for the authenticated account.
    #
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with an array of payment methods
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-api/payment-methods/get
    def get(request_options: nil)
      _get(uri: '/v1/payment_methods', request_options: request_options)
    end
  end
end

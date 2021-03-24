# typed: true
# frozen_string_literal: true

module Mercadopago
  ###
  # Access to Payment Methods

  class PaymentMethods < MPBase
    def get(request_options: nil)
      _get(uri: '/v1/payment_methods', request_options: request_options)
    end
  end
end

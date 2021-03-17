# typed: true
# frozen_string_literal: true

module Mercadopago
  ##
  # This class will allow you to charge your customers through our web form from any device in a simple, fast and secure way.
  # [Click here for more infos](https://www.mercadopago.com.br/developers/en/guides/online-payments/checkout-pro/introduction)

  class Preference < MPBase
    def get(preference_id, request_options: nil)
      _get(uri: "/checkout/preferences/#{preference_id}", request_options: request_options)
    end

    def create(preference_data, request_options: nil)
      raise TypeError, 'Param preference_data must be a Hash' unless preference_data.is_a?(Hash)

      _post(uri: '/checkout/preferences', data: preference_data, request_options: request_options)
    end

    def update(preference_id, preference_data, request_options: nil)
      raise TypeError, 'Param preference_data must be a Hash' unless preference_data.is_a?(Hash)

      _put(uri: "/checkout/preferences/#{preference_id}", data: preference_data, request_options: request_options)
    end
  end
end

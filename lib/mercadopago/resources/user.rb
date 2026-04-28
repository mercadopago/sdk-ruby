# typed: true
# frozen_string_literal: true

module Mercadopago
  # Retrieves the profile of the currently authenticated MercadoPago user.
  #
  # Useful for validating the access token and obtaining the seller's
  # account details (ID, email, site, country, etc.).
  #
  # @see https://www.mercadopago.com/developers/en/reference (users section not found in current reference)
  class User < MPBase
    # Returns the authenticated user's profile.
    #
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with user profile data
    def get(request_options: nil)
      _get(uri: '/users/me', request_options: request_options)
    end
  end
end

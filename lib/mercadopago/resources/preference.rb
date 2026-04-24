# typed: true
# frozen_string_literal: true

module Mercadopago
  # Manages Checkout Pro payment preferences.
  #
  # A preference defines the items, payer info, redirect URLs, and
  # payment configuration for a Checkout Pro session. The API returns
  # an +init_point+ URL that redirects the buyer to the hosted checkout.
  #
  # @see https://www.mercadopago.com/developers/en/reference/preferences/_checkout_preferences/post
  class Preference < MPBase
    # Retrieves an existing preference.
    #
    # @param preference_id [String] preference ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with preference details
    def get(preference_id, request_options: nil)
      _get(uri: "/checkout/preferences/#{preference_id}", request_options: request_options)
    end

    # Creates a new Checkout Pro preference.
    #
    # @param preference_data [Hash] preference attributes (items, payer, back_urls, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created preference (includes +init_point+)
    # @raise [TypeError] if +preference_data+ is not a Hash
    def create(preference_data, request_options: nil)
      raise TypeError, 'Param preference_data must be a Hash' unless preference_data.is_a?(Hash)

      _post(uri: '/checkout/preferences', data: preference_data, request_options: request_options)
    end

    # Updates an existing preference.
    #
    # @param preference_id [String] preference ID
    # @param preference_data [Hash] fields to update
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the updated preference
    # @raise [TypeError] if +preference_data+ is not a Hash
    def update(preference_id, preference_data, request_options: nil)
      raise TypeError, 'Param preference_data must be a Hash' unless preference_data.is_a?(Hash)

      _put(uri: "/checkout/preferences/#{preference_id}", data: preference_data, request_options: request_options)
    end
  end
end

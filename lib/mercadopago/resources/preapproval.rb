# typed: true
# frozen_string_literal: true

module Mercadopago
  # Manages recurring subscriptions (preapprovals).
  #
  # A preapproval authorises MercadoPago to charge the buyer
  # periodically according to the terms defined by a
  # {PreapprovalPlan}. Use this resource to create, update, pause,
  # or cancel individual subscriptions.
  #
  # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/create-preapproval/post
  class Preapproval < MPBase
    # Searches subscriptions matching the given filters.
    #
    # @param filters [Hash, nil] query parameters (e.g. +{ status: "authorized" }+)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with search results
    # @raise [TypeError] if +filters+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/search-preapproval/get
    def search(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/preapproval/search', filters: filters, request_options: request_options)
    end

    # Retrieves a single subscription by ID.
    #
    # @param preapproval_id [String] subscription ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with subscription details
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/get-preapproval/get
    def get(preapproval_id, request_options: nil)
      _get(uri: "/preapproval/#{_path_param(preapproval_id)}", request_options: request_options)
    end

    # Creates a new subscription.
    #
    # @param preapproval_data [Hash] subscription attributes (plan_id, payer_email, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created subscription
    # @raise [TypeError] if +preapproval_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/create-preapproval/post
    def create(preapproval_data, request_options: nil)
      raise TypeError, 'Param preapproval_data must be a Hash' unless preapproval_data.is_a?(Hash)

      _post(uri: '/preapproval/', data: preapproval_data, request_options: request_options)
    end

    # Updates an existing subscription (e.g. pause, resume, or cancel).
    #
    # @param preapproval_id [String] subscription ID
    # @param preapproval_data [Hash] fields to update (e.g. +{ status: "paused" }+)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the updated subscription
    # @raise [TypeError] if +preapproval_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/update-preapproval/put
    def update(preapproval_id, preapproval_data, request_options: nil)
      raise TypeError, 'Param preapproval_data must be a Hash' unless preapproval_data.is_a?(Hash)

      _put(uri: "/preapproval/#{_path_param(preapproval_id)}", data: preapproval_data, request_options: request_options)
    end
  end
end

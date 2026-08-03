# typed: true
# frozen_string_literal: true

module Mercadopago
  # Manages plan-based recurring subscriptions.
  #
  # A subscription ties a payer to a {PreapprovalPlan}, authorising
  # MercadoPago to charge them periodically according to the plan's terms.
  # Requires +preapproval_plan_id+ when creating a new subscription.
  #
  # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/create-preapproval/post
  class Subscription < MPBase
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
    # @param subscription_id [String] subscription ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with subscription details
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/get-preapproval/get
    def get(subscription_id, request_options: nil)
      _get(uri: "/preapproval/#{_path_param(subscription_id)}", request_options: request_options)
    end

    # Creates a new plan-based subscription.
    #
    # @param subscription_data [Hash] subscription attributes; must include +preapproval_plan_id+
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created subscription
    # @raise [TypeError] if +subscription_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/create-preapproval/post
    def create(subscription_data, request_options: nil)
      raise TypeError, 'Param subscription_data must be a Hash' unless subscription_data.is_a?(Hash)

      _post(uri: '/preapproval/', data: subscription_data, request_options: request_options)
    end

    # Updates an existing subscription (e.g. pause, resume, or cancel).
    #
    # @param subscription_id [String] subscription ID
    # @param subscription_data [Hash] fields to update (e.g. +{ status: "paused" }+)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the updated subscription
    # @raise [TypeError] if +subscription_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/update-preapproval/put
    def update(subscription_id, subscription_data, request_options: nil)
      raise TypeError, 'Param subscription_data must be a Hash' unless subscription_data.is_a?(Hash)

      _put(uri: "/preapproval/#{_path_param(subscription_id)}", data: subscription_data, request_options: request_options)
    end
  end
end

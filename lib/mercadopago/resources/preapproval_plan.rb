# typed: true
# frozen_string_literal: true

module Mercadopago
  # Manages subscription plan templates (preapproval plans).
  #
  # A plan defines the recurring billing terms (frequency, amount,
  # currency) that one or more {Preapproval} subscriptions can
  # reference. Create a plan once, then associate subscribers to it.
  #
  # @see https://www.mercadopago.com/developers/en/reference/subscriptions/_preapproval_plan/post
  class PreapprovalPlan < MPBase
    # Searches subscription plans matching the given filters.
    #
    # @param filters [Hash, nil] query parameters
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with search results
    # @raise [TypeError] if +filters+ is not a Hash
    def search(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/preapproval_plan/search', filters: filters, request_options: request_options)
    end

    # Retrieves a single subscription plan by ID.
    #
    # @param preapproval_plan_id [String] plan ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with plan details
    def get(preapproval_plan_id, request_options: nil)
      _get(uri: "/preapproval_plan/#{preapproval_plan_id}", request_options: request_options)
    end

    # Creates a new subscription plan.
    #
    # @param preapproval_plan_data [Hash] plan attributes (reason, auto_recurring, back_url, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created plan
    # @raise [TypeError] if +preapproval_plan_data+ is not a Hash
    def create(preapproval_plan_data, request_options: nil)
      raise TypeError, 'Param preapproval_plan_data must be a Hash' unless preapproval_plan_data.is_a?(Hash)

      _post(uri: '/preapproval_plan/', data: preapproval_plan_data, request_options: request_options)
    end

    # Updates an existing subscription plan.
    #
    # @param preapproval_plan_id [String] plan ID
    # @param preapproval_plan_data [Hash] fields to update
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the updated plan
    # @raise [TypeError] if +preapproval_plan_data+ is not a Hash
    def update(preapproval_plan_id, preapproval_plan_data, request_options: nil)
      raise TypeError, 'Param preapproval_plan_data must be a Hash' unless preapproval_plan_data.is_a?(Hash)

      _put(uri: "/preapproval_plan/#{preapproval_plan_id}", data: preapproval_plan_data, request_options: request_options)
    end
  end
end

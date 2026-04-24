# typed: true
# frozen_string_literal: true

module Mercadopago
  # Manages customer records for the authenticated MercadoPago account.
  #
  # Storing customer data enables one-click purchases when combined with
  # the {Card} resource, which links saved cards to customers.
  #
  # @see https://www.mercadopago.com/developers/en/reference/customers/_customers/post
  class Customer < MPBase
    # Searches customers matching the given filters.
    #
    # @param filters [Hash, nil] query parameters (e.g. +{ email: "user@example.com" }+)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with search results
    def search(filters: nil, request_options: nil)
      _get(uri: '/v1/customers/search', filters: filters, request_options: request_options)
    end

    # Retrieves a single customer by ID.
    #
    # @param customer_id [String] MercadoPago customer ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with customer details
    def get(customer_id, request_options: nil)
      _get(uri: "/v1/customers/#{customer_id}", request_options: request_options)
    end

    # Creates a new customer.
    #
    # @param customer_data [Hash] customer attributes (email, first_name, identification, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created customer
    # @raise [TypeError] if +customer_data+ is not a Hash
    def create(customer_data, request_options: nil)
      raise TypeError, 'Param customer_data must be a Hash' unless customer_data.is_a?(Hash)

      _post(uri: '/v1/customers', data: customer_data, request_options: request_options)
    end

    # Updates an existing customer.
    #
    # @param customer_id [String] MercadoPago customer ID
    # @param customer_data [Hash] fields to update
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the updated customer
    # @raise [TypeError] if +customer_data+ is not a Hash
    def update(customer_id, customer_data, request_options: nil)
      raise TypeError, 'Param customer_data must be a Hash' unless customer_data.is_a?(Hash)

      _put(uri: "/v1/customers/#{customer_id}", data: customer_data, request_options: request_options)
    end

    # Deletes a customer permanently.
    #
    # @param customer_id [String] MercadoPago customer ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+
    def delete(customer_id, request_options: nil)
      _delete(uri: "/v1/customers/#{customer_id}", request_options: request_options)
    end
  end
end

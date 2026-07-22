# typed: true
# frozen_string_literal: true

module Mercadopago
  # Manages individual transactions within an {Order}.
  #
  # Each transaction represents a payment attempt or payment method
  # attached to an order. You can add, update, or remove transactions
  # before the order is processed.
  #
  # @see https://www.mercadopago.com/developers/en/docs/checkout-api/landing
  class OrderTransaction < MPBase
    # Adds a new transaction to an order.
    #
    # @param order_id [String] parent order ID
    # @param order_transaction_data [Hash] transaction attributes (payment method, amount, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created transaction
    # @raise [TypeError] if +order_transaction_data+ is not a Hash
    def create(order_id, order_transaction_data, request_options: nil)
      raise TypeError, 'Param order_transaction_data must be a Hash' unless order_transaction_data.is_a?(Hash)

      _post(uri: "/v1/orders/#{_path_param(order_id)}/transactions", data: order_transaction_data, request_options: request_options)
    end

    # Updates an existing transaction within an order.
    #
    # @param order_id [String] parent order ID
    # @param transaction_id [String] transaction ID to update
    # @param order_transaction_data [Hash] fields to update
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the updated transaction
    # @raise [TypeError] if +order_transaction_data+ is not a Hash
    def update(order_id, transaction_id, order_transaction_data, request_options: nil)
      raise TypeError, 'Param order_transaction_data must be a Hash' unless order_transaction_data.is_a?(Hash)

      _put(uri: "/v1/orders/#{_path_param(order_id)}/transactions/#{_path_param(transaction_id)}", data: order_transaction_data, request_options: request_options)
    end

    # Removes a transaction from an order.
    #
    # @param order_id [String] parent order ID
    # @param transaction_id [String] transaction ID to delete
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+
    def delete(order_id, transaction_id, request_options: nil)
      _delete(uri: "/v1/orders/#{_path_param(order_id)}/transactions/#{_path_param(transaction_id)}", request_options: request_options)
    end
  end
end

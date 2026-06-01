# typed: true
# frozen_string_literal: true

module Mercadopago
  # Manages orders through the Checkout API v1.
  #
  # An order groups one or more transactions and supports the full
  # lifecycle: create, process, capture, refund, cancel, and search.
  # Use {OrderTransaction} to manage individual transactions within
  # an order.
  #
  # == Automatic Payments (AP) — supported Hash keys for +stored_credential+
  #
  #   {
  #     payment_initiator:    String,   # "cardholder" | "merchant"
  #     reason:               String,   # "recurring" | "installment" | "unscheduled"
  #     store_payment_method: Boolean,
  #     first_payment:        Boolean,
  #     prev_transaction_ref: String    # ID of the previous transaction in the series.
  #                                     # Required from the second charge onwards.
  #   }
  #
  # == Supported Hash keys for +automatic_payments+
  #
  #   {
  #     payment_profile_id: String,   # Stored payment profile ID.
  #     retries:            Integer,  # Max retry attempts on failure.
  #     schedule_date:      String,   # ISO 8601 scheduled charge date.
  #     due_date:           String    # ISO 8601 payment due date.
  #   }
  #
  # == Supported Hash keys for +subscription_data+
  #
  #   {
  #     invoice_id:   String,  # ID of the invoice being paid.
  #     billing_date: String,  # ISO 8601 billing date.
  #     subscription_sequence: {
  #       number: Integer,     # Current payment number (1-based).
  #       total:  Integer      # Total payments in the plan.
  #     },
  #     invoice_period: {
  #       type:   String,      # "monthly" | "daily" | "yearly".
  #       period: Integer      # Number of period units.
  #     }
  #   }
  #
  # == Supported Hash keys for +integration_data+ (root of order request)
  #
  #   {
  #     integrator_id:  String,  # Certified integrator ID.
  #     platform_id:    String,  # Platform ID assigned by MercadoPago.
  #     corporation_id: String,  # Corporation ID for multi-account setups.
  #     sponsor: {
  #       id: String             # MercadoPago user ID of the sponsor.
  #     }
  #   }
  #
  # @see https://www.mercadopago.com/developers/en/docs/checkout-api/landing
  class Order < MPBase
    # Creates a new order.
    #
    # @param order_data [Hash] order attributes (type, total_amount, transactions, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created order
    # @raise [TypeError] if +order_data+ is not a Hash
    def create(order_data, request_options: nil)
      raise TypeError, 'Param order_data must be a Hash' unless order_data.is_a?(Hash)

      _post(uri: '/v1/orders', data: order_data, request_options: request_options)
    end

    # Retrieves a single order by ID.
    #
    # @param order_id [String] order ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with order details
    def get(order_id, request_options: nil)
      _get(uri: "/v1/orders/#{order_id}", request_options: request_options)
    end

    # Processes (confirms) an order, triggering payment execution.
    #
    # @param order_id [String] order ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the processed order
    def process(order_id, request_options: nil)
      _post(uri: "/v1/orders/#{order_id}/process", data: nil, request_options: request_options)
    end

    # Refunds an order (full or partial).
    #
    # Omit +refund_data+ for a full refund, or pass +{ amount: 10.0 }+
    # for a partial refund.
    #
    # @param order_id [String] order ID
    # @param refund_data [Hash, nil] optional refund attributes
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the refund result
    # @raise [TypeError] if +refund_data+ is provided but is not a Hash
    def refund(order_id, refund_data: nil, request_options: nil)
      raise TypeError, 'Param refund_data must be a Hash' unless refund_data.nil? || refund_data.is_a?(Hash)

      _post(uri: "/v1/orders/#{order_id}/refund", data: refund_data, request_options: request_options)
    end

    # Cancels an order that has not yet been captured.
    #
    # @param order_id [String] order ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the cancelled order
    def cancel(order_id, request_options: nil)
      _post(uri: "/v1/orders/#{order_id}/cancel", data: nil, request_options: request_options)
    end

    # Captures a previously authorized order.
    #
    # @param order_id [String] order ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the captured order
    def capture(order_id, request_options: nil)
      _post(uri: "/v1/orders/#{order_id}/capture", data: nil, request_options: request_options)
    end

    # Searches orders matching the given filters.
    #
    # @param filters [Hash, nil] query parameters
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with search results
    def search(filters: nil, request_options: nil)
      _get(uri: '/v1/orders', params: filters, request_options: request_options)
    end
  end
end

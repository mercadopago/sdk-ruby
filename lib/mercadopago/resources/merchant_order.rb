# typed: true
# frozen_string_literal: true

module Mercadopago
  # Groups one or more payments into a single merchant order.
  #
  # Merchant orders are useful for marketplace and multi-payment
  # scenarios where you need to track the fulfilment status of
  # several payments as a unit.
  #
  # @see https://www.mercadopago.com/developers/en/reference/
  class MerchantOrder < MPBase
    # Searches merchant orders matching the given filters.
    #
    # @param filters [Hash, nil] query parameters
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with search results
    # @raise [TypeError] if +filters+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-pro/merchant_orders/search-merchant-order/get
    def search(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/merchant_orders/search', filters: filters, request_options: request_options)
    end

    # Retrieves a single merchant order by ID.
    #
    # @param merchant_order_id [Integer, String] merchant order ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with order details
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-pro/merchant_orders/get-merchant-order/get
    def get(merchant_order_id, request_options: nil)
      _get(uri: "/merchant_orders/#{merchant_order_id}", request_options: request_options)
    end

    # Creates a new merchant order.
    #
    # @param merchant_order_data [Hash] order attributes (items, preference_id, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created order
    # @raise [TypeError] if +merchant_order_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/
    def create(merchant_order_data, request_options: nil)
      raise TypeError, 'Param merchant_orders_object must be a Hash' unless merchant_order_data.is_a?(Hash)

      _post(uri: '/merchant_orders', data: merchant_order_data, request_options: request_options)
    end

    # Updates an existing merchant order.
    #
    # @param merchant_order_id [Integer, String] merchant order ID
    # @param merchant_order_data [Hash] fields to update
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the updated order
    # @raise [TypeError] if +merchant_order_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/checkout-pro/merchant_orders/update-merchant-order/put
    def update(merchant_order_id, merchant_order_data, request_options: nil)
      raise TypeError, 'Param merchant_orders_object must be a Hash' unless merchant_order_data.is_a?(Hash)

      _put(uri: "/merchant_orders/#{merchant_order_id}", data: merchant_order_data,
           request_options: request_options)
    end
  end
end

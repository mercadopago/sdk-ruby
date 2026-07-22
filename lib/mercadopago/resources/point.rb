# typed: true
# frozen_string_literal: true

module Mercadopago
  # Manages payment intents on MercadoPago Point (POS) devices.
  #
  # Enables in-person payment processing by creating payment intents
  # that are sent to a physical Point device for the buyer to complete
  # the transaction by inserting or tapping their card.
  #
  # Note: The +change_operating_mode+ operation (PATCH
  # +/point/integration-api/devices/{device_id}+) is not included because
  # the Ruby SDK HTTP client does not currently expose a PATCH method.
  #
  # @see https://www.mercadopago.com/developers/en/reference/in-person-payments/point/orders/create-order/post
  class Point < MPBase
    # Lists Point devices linked to the authenticated account.
    #
    # @param filters [Hash, nil] optional query parameters (e.g. +store_id+, +pos_id+)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with a list of devices
    # @raise [TypeError] if +filters+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/in-person-payments/point/devices/list-devices/get
    def get_devices(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/point/integration-api/devices', filters: filters, request_options: request_options)
    end

    # Creates a payment intent on a specific Point device.
    #
    # The payment intent is sent to the physical device, where the buyer
    # completes the transaction.
    #
    # @param device_id [String] unique identifier of the target Point device
    # @param payment_intent_data [Hash] payment intent attributes (+amount+,
    #   +description+, +payment+ method details, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created intent
    # @raise [TypeError] if +payment_intent_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/in-person-payments/point/orders/create-order/post
    def create(device_id, payment_intent_data, request_options: nil)
      raise TypeError, 'Param payment_intent_data must be a Hash' unless payment_intent_data.is_a?(Hash)

      _post(
        uri: "/point/integration-api/devices/#{_path_param(device_id)}/payment-intents",
        data: payment_intent_data,
        request_options: request_options
      )
    end

    # Retrieves the current state of a payment intent by its ID.
    #
    # Use this to check whether the buyer has completed, cancelled, or is
    # still processing the payment on the device.
    #
    # @param payment_intent_id [String] unique identifier of the payment intent
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with intent details
    #   including +:state+ and, when completed, +:payment_id+
    # @see https://www.mercadopago.com/developers/en/reference/in-person-payments/point/orders/get-order/get
    def get(payment_intent_id, request_options: nil)
      _get(
        uri: "/point/integration-api/payment-intents/#{_path_param(payment_intent_id)}",
        request_options: request_options
      )
    end

    # Cancels a pending payment intent on a specific device.
    #
    # Use this to abort a transaction before the buyer completes the
    # payment on the device.
    #
    # @param device_id [String] unique identifier of the Point device holding the intent
    # @param payment_intent_id [String] unique identifier of the payment intent to cancel
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with cancellation confirmation
    # @see https://www.mercadopago.com/developers/en/reference/in-person-payments/point/orders/cancel-order/post
    def cancel(device_id, payment_intent_id, request_options: nil)
      _delete(
        uri: "/point/integration-api/devices/#{_path_param(device_id)}/payment-intents/#{_path_param(payment_intent_id)}",
        request_options: request_options
      )
    end
  end
end

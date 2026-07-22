# typed: false
# frozen_string_literal: true

module Mercadopago
  # Manages advanced (split) payments for marketplace integrations.
  #
  # Advanced payments allow a marketplace to split a single buyer
  # transaction across multiple sellers, each receiving their own
  # disbursement. Supports authorization/capture flows, cancellation,
  # and release-date adjustments.
  #
  # @see https://www.mercadopago.com/developers/en/reference (advanced_payments section not found in current reference)
  class AdvancedPayment < MPBase
    # Searches advanced payments matching the given filters.
    #
    # @param filters [Hash, nil] query parameters
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with search results
    # @raise [TypeError] if +filters+ is not a Hash
    def search(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/v1/advanced_payments/search', filters: filters, request_options: request_options)
    end

    # Retrieves a single advanced payment by ID.
    #
    # @param advanced_payment_id [Integer, String] advanced payment ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with payment details
    def get(advanced_payment_id, request_options: nil)
      _get(uri: "/v1/advanced_payments/#{_path_param(advanced_payment_id)}", request_options: request_options)
    end

    # Creates a new advanced payment with split disbursements.
    #
    # @param advanced_payment_data [Hash] payment attributes (payer, payments array, disbursements, etc.)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created payment
    # @raise [TypeError] if +advanced_payment_data+ is not a Hash
    def create(advanced_payment_data, request_options: nil)
      raise TypeError, 'Param advanced_payment_data must be a Hash' unless advanced_payment_data.is_a?(Hash)

      _post(uri: '/v1/advanced_payments', data: advanced_payment_data, request_options: request_options)
    end

    # Captures a previously authorized advanced payment.
    #
    # Sends +{ capture: true }+ to transition the payment from
    # authorized to captured state.
    #
    # @param advanced_payment_id [Integer, String] advanced payment ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the captured payment
    def capture(advanced_payment_id, request_options: nil)
      capture_data = { capture: true }
      _put(uri: "/v1/advanced_payments/#{_path_param(advanced_payment_id)}", data: capture_data, request_options: request_options)
    end

    # Updates an existing advanced payment.
    #
    # @param advanced_payment_id [Integer, String] advanced payment ID
    # @param advanced_payment_data [Hash] fields to update
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the updated payment
    # @raise [TypeError] if +advanced_payment_data+ is not a Hash
    def update(advanced_payment_id, advanced_payment_data, request_options: nil)
      raise TypeError, 'Param advanced_payment_data must be a Hash' unless advanced_payment_data.is_a?(Hash)

      _put(uri: "/v1/advanced_payments/#{_path_param(advanced_payment_id)}", data: advanced_payment_data,
           request_options: request_options)
    end

    # Cancels an advanced payment by setting its status to "cancelled".
    #
    # @param advanced_payment_id [Integer, String] advanced payment ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the cancelled payment
    def cancel(advanced_payment_id, request_options: nil)
      cancel_data = { status: 'cancelled' }
      _put(uri: "/v1/advanced_payments/#{_path_param(advanced_payment_id)}", data: cancel_data, request_options: request_options)
    end

    # Changes the money release date for an advanced payment's disbursements.
    #
    # @param advanced_payment_id [Integer, String] advanced payment ID
    # @param release_date [Time, DateTime] new release date (formatted as "%Y-%m-%d %H:%M:%S.%f")
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+
    def update_release_date(advanced_payment_id, release_date, request_options: nil)
      disbursement_data = { money_release_date: release_date.strftime('%Y-%m-%d %H:%M:%S.%f') }
      _post(uri: "/v1/advanced_payments/#{_path_param(advanced_payment_id)}/disburses", data: disbursement_data,
            request_options: request_options)
    end
  end
end

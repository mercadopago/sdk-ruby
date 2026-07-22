# typed: true
# frozen_string_literal: true

module Mercadopago
  # Provides read access to subscription invoices (authorized payments).
  #
  # Each invoice corresponds to a billing cycle of a {Preapproval} and
  # tracks the charge amount, status, retry attempts, and the resulting
  # payment. Use {#get} and {#search} to monitor billing cycles and their
  # outcomes.
  #
  # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/get-authorized-payment/get
  class Invoice < MPBase
    # Retrieves a single invoice (authorized payment) by its ID.
    #
    # @param invoice_id [Integer, String] unique invoice identifier
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the full invoice object
    #   including +:status+, +:transaction_amount+, +:preapproval_id+, and +:payment+ details
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/get-authorized-payment/get
    def get(invoice_id, request_options: nil)
      _get(uri: "/authorized_payments/#{_path_param(invoice_id)}", request_options: request_options)
    end

    # Searches invoices matching the given filters.
    #
    # @param filters [Hash, nil] query parameters such as +:preapproval_id+,
    #   +:status+, +:payer_id+, +:offset+, and +:limit+
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with +:paging+ metadata
    #   and a +:results+ list of matching invoices
    # @raise [TypeError] if +filters+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/online-payments/subscriptions/authorized-payment-search/get
    def search(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/authorized_payments/search', filters: filters, request_options: request_options)
    end
  end
end

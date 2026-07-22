# typed: true
# frozen_string_literal: true

module Mercadopago
  # Provides read access to chargeback disputes.
  #
  # Chargebacks are initiated by cardholders through their issuing bank
  # when they dispute a payment. Use {#get} and {#search} to monitor and
  # respond to disputes.
  #
  # @see https://www.mercadopago.com.br/developers/en/reference/chargebacks/
  class Chargeback < MPBase
    # Retrieves a chargeback by its ID.
    #
    # @param chargeback_id [Integer, String] unique chargeback identifier
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the full chargeback object
    # @see https://www.mercadopago.com.br/developers/en/reference/chargebacks/
    def get(chargeback_id, request_options: nil)
      _get(uri: "/v1/chargebacks/#{_path_param(chargeback_id)}", request_options: request_options)
    end

    # Searches chargebacks matching the given filters.
    #
    # @param filters [Hash, nil] query parameters (e.g. +:payment_id+, +:status+)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with a paginated list of chargebacks
    # @raise [TypeError] if +filters+ is not a Hash
    # @see https://www.mercadopago.com.br/developers/en/reference/chargebacks/
    def search(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/v1/chargebacks/search', filters: filters, request_options: request_options)
    end
  end
end

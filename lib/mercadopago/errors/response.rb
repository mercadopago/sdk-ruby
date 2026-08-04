# frozen_string_literal: true

module Mercadopago
  # Backward-compatible Hash wrapper for MercadoPago API responses.
  #
  # Wraps the raw +{ status:, response: }+ hash returned by every
  # {MPBase} helper. Existing code that reads +result[:status]+ or
  # +result[:response]+ continues to work unchanged.
  #
  # New code may call {#raise_for_status!} to get a typed exception or
  # use the convenience accessors {#success?}, {#error_message}, {#error_causes}.
  class MPResponse < Hash
    # @param raw [Hash] the raw response hash with +:status+ and +:response+ keys
    # @param request_id [String, nil] value of the +x-request-id+ response header
    def initialize(raw = {}, request_id: nil)
      super()
      update(raw)
      @request_id = request_id
    end

    # @return [Integer] HTTP status code
    def status_code
      self[:status] || self['status'] || 0
    end

    # @return [Boolean] true for 2xx status codes
    def success?
      status_code >= 200 && status_code < 300
    end

    # @return [String] human-readable error message from the API body
    def error_message
      body = self[:response] || self['response'] || {}
      body.is_a?(Hash) ? (body['message'] || body[:message] || '') : ''
    end

    # @return [Array] cause list from the API body
    def error_causes
      body = self[:response] || self['response'] || {}
      body.is_a?(Hash) ? (body['cause'] || body[:cause] || []) : []
    end

    # @return [String, nil] x-request-id header value
    def request_id
      @request_id
    end

    # Raises a typed {MercadoPagoError} subclass when the response status is not 2xx.
    #
    # @raise [MercadoPagoError] (or subtype) when status >= 300
    def raise_for_status!
      return if success?

      body = self[:response] || self['response'] || {}
      raise Mercadopago.build_error(status_code, body)
    end
  end
end

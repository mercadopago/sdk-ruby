# frozen_string_literal: true

module Mercadopago
  # Base exception for all MercadoPago API errors.
  #
  # All subtypes inherit from this class, preserving backward-compatible
  # +rescue MercadoPagoError+ patterns while enabling specific handling
  # per HTTP status code.
  #
  # @attr_reader [Integer] status_code HTTP status code (e.g. 400, 401, 500)
  # @attr_reader [String]  error       Machine-readable error code from the API body
  # @attr_reader [Array]   causes      List of detailed cause hashes from the API body
  # @attr_reader [String, nil] request_id x-request-id header for support diagnostics
  class MercadoPagoError < StandardError
    attr_reader :status_code, :error, :causes, :request_id

    # @param status_code [Integer] HTTP status code
    # @param response_body [Hash] parsed API error body
    # @param request_id [String, nil] value of the x-request-id response header
    def initialize(status_code, response_body = nil, request_id = nil)
      body = (response_body.is_a?(Hash) ? response_body : {})
      super(body['message'] || body[:message] || body['error'] || body[:error] || 'MercadoPago API error')
      @status_code = status_code
      @error       = body['error']  || body[:error]  || ''
      @causes      = body['cause']  || body[:cause]  || []
      @request_id  = request_id
    end
  end

  # HTTP 400 Bad Request — validation or syntax error.
  class MPBadRequestError < MercadoPagoError; end

  # HTTP 401 Unauthorized — missing or invalid credentials.
  class MPAuthenticationError < MercadoPagoError; end

  # HTTP 402 Payment Required — transaction processing error (AP/Orders).
  class MPPaymentError < MercadoPagoError; end

  # HTTP 403 Forbidden.
  class MPForbiddenError < MercadoPagoError; end

  # HTTP 404 Not Found.
  class MPNotFoundError < MercadoPagoError; end

  # HTTP 409 Conflict — idempotency-key conflict or state-machine conflict.
  class MPIdempotencyError < MercadoPagoError; end

  # HTTP 422 Unprocessable Entity — business-rule violation.
  class MPValidationError < MercadoPagoError; end

  # HTTP 423 Locked — idempotency key temporarily locked (retryable).
  class MPResourceLockedError < MercadoPagoError; end

  # HTTP 424 Failed Dependency — internal dependency failure (retryable).
  class MPDependencyError < MercadoPagoError; end

  # HTTP 429 Too Many Requests.
  # Exposes +retry_after+ (seconds) from the +Retry-After+ response header.
  #
  # @attr_reader [Integer, nil] retry_after seconds to wait before retrying
  class MPRateLimitError < MercadoPagoError
    attr_reader :retry_after

    def initialize(status_code, response_body = nil, retry_after = nil, request_id = nil)
      super(status_code, response_body, request_id)
      @retry_after = retry_after
    end
  end

  # HTTP 5xx Server Error.
  class MPServerError < MercadoPagoError; end

  # Transport-level or network error (timeout, DNS failure, SSL error).
  class MPConnectionError < MercadoPagoError
    def initialize(cause)
      super(0, { 'error' => 'connection_error', 'message' => cause.to_s })
    end
  end

  # @!visibility private
  STATUS_MAP = {
    400 => MPBadRequestError,
    401 => MPAuthenticationError,
    402 => MPPaymentError,
    403 => MPForbiddenError,
    404 => MPNotFoundError,
    409 => MPIdempotencyError,
    422 => MPValidationError,
    423 => MPResourceLockedError,
    424 => MPDependencyError
  }.freeze

  # Factory: maps an HTTP status code to the most specific exception subtype.
  #
  # @param status_code [Integer] HTTP status code from the API response
  # @param response_body [Hash] parsed API error body
  # @param retry_after [Integer, nil] seconds from Retry-After header (429 only)
  # @return [MercadoPagoError] the appropriate subtype instance
  def self.build_error(status_code, response_body = nil, retry_after = nil)
    return MPRateLimitError.new(status_code, response_body, retry_after) if status_code == 429

    klass = STATUS_MAP[status_code]
    return klass.new(status_code, response_body) if klass
    return MPServerError.new(status_code, response_body) if status_code >= 500

    MercadoPagoError.new(status_code, response_body)
  end
end

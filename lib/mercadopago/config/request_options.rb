# typed: true
# frozen_string_literal: true

module Mercadopago
  # Encapsulates per-request configuration: authentication, timeouts,
  # retry policy, and optional MercadoPago partner/platform headers.
  #
  # An instance is created automatically by {SDK#initialize} but can
  # also be built manually and passed to individual resource calls
  # via the +request_options:+ keyword to override the SDK defaults.
  #
  # @example Override timeout for a single call
  #   opts = Mercadopago::RequestOptions.new(access_token: token, connection_timeout: 120.0)
  #   sdk.payment.get(123, request_options: opts)
  class RequestOptions
    DEFAULT_RETRY_ON  = [429, 500, 502, 503, 504].freeze
    DEFAULT_MAX_DELAY = 30_000

    # @!attribute [r] access_token
    #   @return [String, nil] OAuth access token used for Bearer authentication
    # @!attribute [r] connection_timeout
    #   @return [Float] HTTP timeout in seconds (default: 60.0)
    # @!attribute [r] custom_headers
    #   @return [Hash, nil] extra headers merged into every request
    # @!attribute [r] corporation_id
    #   @return [String, nil] MercadoPago corporation identifier (x-corporation-id header)
    # @!attribute [r] integrator_id
    #   @return [String, nil] MercadoPago integrator identifier (x-integrator-id header)
    # @!attribute [r] platform_id
    #   @return [String, nil] MercadoPago platform identifier (x-platform-id header)
    # @!attribute [r] max_retries
    #   @return [Integer] maximum automatic retries on transient HTTP errors (default: 3)
    # @!attribute [r] initial_delay_ms
    #   @return [Integer, nil] initial backoff delay in ms (nil = SDK default)
    # @!attribute [r] max_delay_ms
    #   @return [Integer] maximum backoff delay cap in ms (default: 30_000)
    # @!attribute [r] jitter
    #   @return [Boolean] add random jitter to retry delay using SecureRandom
    # @!attribute [r] retry_on
    #   @return [Array<Integer>, nil] HTTP status codes to retry (nil = DEFAULT_RETRY_ON)
    # @!attribute [r] on_retry
    #   @return [Proc, nil] callback(attempt, error) invoked before each retry
    attr_reader :access_token, :connection_timeout, :custom_headers, :corporation_id, :integrator_id,
                :platform_id, :max_retries, :initial_delay_ms, :max_delay_ms, :jitter, :retry_on, :on_retry

    # Builds a new request configuration.
    #
    # @param access_token [String, nil] OAuth access token
    # @param connection_timeout [Float] HTTP timeout in seconds
    # @param custom_headers [Hash, nil] additional headers to include
    # @param corporation_id [String, nil] corporation identifier for partner integrations
    # @param integrator_id [String, nil] integrator identifier for certified partners
    # @param platform_id [String, nil] platform identifier for marketplace integrations
    # @param max_retries [Integer] retry limit for transient failures (429, 5xx)
    # @param initial_delay_ms [Integer, nil] initial backoff delay in ms
    # @param max_delay_ms [Integer] maximum backoff delay cap in ms
    # @param jitter [Boolean] add SecureRandom jitter to retry delay
    # @param retry_on [Array<Integer>, nil] HTTP status codes to retry
    # @param on_retry [Proc, nil] callback invoked before each retry
    # @raise [TypeError] if any parameter is not the expected type
    def initialize(access_token: nil,
                   connection_timeout: 60.0,
                   custom_headers: nil,
                   corporation_id: nil,
                   integrator_id: nil,
                   platform_id: nil,
                   max_retries: 3,
                   initial_delay_ms: nil,
                   max_delay_ms: DEFAULT_MAX_DELAY,
                   jitter: false,
                   retry_on: nil,
                   on_retry: nil)
      self.access_token = access_token
      self.connection_timeout = connection_timeout
      self.custom_headers = custom_headers
      self.corporation_id = corporation_id
      self.integrator_id = integrator_id
      self.platform_id = platform_id
      self.max_retries = max_retries
      @initial_delay_ms = initial_delay_ms
      @max_delay_ms     = max_delay_ms
      @jitter           = jitter
      @retry_on         = retry_on
      @on_retry         = on_retry

      @config = Config.new
    end

    # Builds the full HTTP headers hash for a request.
    #
    # Includes authorization, tracking, idempotency, user-agent, and
    # any optional partner/custom headers. A unique idempotency key
    # (UUID v4) is generated on every call.
    #
    # @return [Hash] merged headers ready to be sent with the HTTP request
    def get_headers
      headers = { 'Authorization': "Bearer #{@access_token}",
                  'x-product-id' => @config.product_id,
                  'x-tracking-id' => @config.tracking_id,
                  'x-idempotency-key' => SecureRandom.uuid,
                  'User-Agent' => @config.user_agent,
                  'Accept': @config.mime_json }

      headers['x-corporation-id'] = @corporation_id unless @corporation_id.nil?
      headers['x-integrator-id'] = @integrator_id unless @integrator_id.nil?
      headers['x-platform-id'] = @platform_id unless @platform_id.nil?

      merge_custom_headers(headers)
    end

    # @param value [String, nil] OAuth access token
    # @raise [TypeError] if value is not a String (nil allowed only when current value is nil)
    def access_token=(value)
      raise TypeError, 'Param access_token must be a String' unless access_token.nil? || value.is_a?(String)

      @access_token = value
    end

    # @param value [Hash, nil] custom headers hash
    # @raise [TypeError] if value is not a Hash or nil
    def custom_headers=(value)
      raise TypeError, 'Param custom_headers must be a Hash' unless value.nil? || value.is_a?(Hash)

      @custom_headers = value
    end

    # @param value [Float] connection timeout in seconds
    # @raise [TypeError] if value is not a Float
    def connection_timeout=(value)
      raise TypeError, 'Param connection_timeout must be a Float' unless value.is_a?(Float)

      @connection_timeout = value
    end

    # @param value [String, nil] corporation identifier
    # @raise [TypeError] if value is not a String or nil
    def corporation_id=(value)
      raise TypeError, 'Param corporation_id must be a String' unless value.nil? || value.is_a?(String)

      @corporation_id = value
    end

    # @param value [String, nil] integrator identifier
    # @raise [TypeError] if value is not a String or nil
    def integrator_id=(value)
      raise TypeError, 'Param integrator_id must be a String' unless value.nil? || value.is_a?(String)

      @integrator_id = value
    end

    # @param value [String, nil] platform identifier
    # @raise [TypeError] if value is not a String or nil
    def platform_id=(value)
      raise TypeError, 'Param platform_id must be a String' unless value.nil? || value.is_a?(String)

      @platform_id = value
    end

    # @param value [Integer] maximum retry count
    # @raise [TypeError] if value is not an Integer
    def max_retries=(value)
      raise TypeError, 'Param max_retries must be a Integer' unless value.is_a?(Integer)

      @max_retries = value
    end

    private

    def merge_custom_headers(headers)
      return headers if @custom_headers.nil?

      custom_header_names = @custom_headers.keys.map { |key| key.to_s.downcase }
      headers.reject! { |key, _value| custom_header_names.include?(key.to_s.downcase) }
      headers.merge!(@custom_headers)
    end
  end
end

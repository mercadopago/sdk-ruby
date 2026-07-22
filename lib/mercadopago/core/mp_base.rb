# typed: false
# frozen_string_literal: true

require 'cgi'

module Mercadopago
  # Abstract base class for every API resource (Payment, Customer, Order, etc.).
  #
  # Provides internal HTTP helper methods (+_get+, +_post+, +_put+, +_delete+)
  # that prepend the API base URL, inject authentication headers, serialise
  # payloads to JSON, and delegate to {HttpClient}.
  #
  # Subclasses only need to call these helpers with the appropriate URI and
  # data; they should never interact with {HttpClient} directly.
  #
  # @abstract Subclass and use the +_get+/+_post+/+_put+/+_delete+ helpers.
  class MPBase
    # @param request_options [RequestOptions] authentication and request configuration
    # @param http_client [HttpClient] transport layer for HTTP calls
    # @raise [TypeError] if +request_options+ is not a {RequestOptions} instance
    def initialize(request_options, http_client)
      unless request_options.is_a?(RequestOptions)
        raise TypeError,
              'Param request_options must be a RequestOptions object'
      end

      @request_options = request_options
      @http_client = http_client
      @config = Config.new
    end

    # Validates and resolves the request options for a single call.
    #
    # Falls back to the instance-level options when none are provided,
    # and inherits the access token from the instance options when the
    # override does not include one.
    #
    # @param request_options [RequestOptions, nil] per-call override
    # @return [RequestOptions] resolved options ready for use
    # @raise [TypeError] if the value is not a {RequestOptions} instance
    def _check_request_options(request_options = nil)
      request_options = @request_options if request_options.nil?
      unless request_options.is_a?(RequestOptions)
        raise TypeError,
              'Param request_options must be a RequestOptions object'
      end

      request_options.access_token = @request_options.access_token if request_options.access_token.nil?

      request_options
    end

    # Builds the HTTP headers hash, merging any extra headers on top.
    #
    # @param request_options [RequestOptions, nil] source of base headers
    # @param extra_headers [Hash, nil] additional headers (e.g. Content-Type)
    # @return [Hash] merged headers ready for the HTTP call
    def _check_headers(request_options = nil, extra_headers = nil)
      headers = request_options.nil? ? @request_options.get_headers : request_options.get_headers

      headers.merge!(extra_headers) unless extra_headers.nil?

      headers
    end

    # Encodes a dynamic URL path segment before interpolation.
    def _path_param(value)
      CGI.escape(value.to_s).gsub('+', '%20')
    end

    # Performs a GET request against the MercadoPago API.
    #
    # @param uri [String] API path (e.g. "/v1/payments/123")
    # @param filters [Hash, nil] query-string parameters
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+
    # @raise [TypeError] if +filters+ is not a Hash
    def _get(uri:, filters: nil, request_options: nil)
      raise TypeError, 'Filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      request_options = _check_request_options(request_options)
      headers = _check_headers(request_options)

      @http_client.get(url: @config.api_base_url + uri, headers: headers, params: filters,
                       timeout: request_options.connection_timeout, maxretries: request_options.max_retries)
    end

    # Performs a POST request against the MercadoPago API.
    #
    # Serialises +data+ to JSON before sending.
    #
    # @param uri [String] API path (e.g. "/v1/payments/")
    # @param data [Hash, nil] request body (will be JSON-encoded)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+
    # @raise [TypeError] if +data+ is not a Hash
    def _post(uri:, data:, request_options: nil)
      raise TypeError, 'Data must be a Hash' unless data.nil? || data.is_a?(Hash)

      request_options = _check_request_options(request_options)
      headers = _check_headers(request_options, { 'Content-Type': @config.mime_json })
      payload = data&.to_json

      @http_client.post(url: @config.api_base_url + uri, data: payload, headers: headers, timeout: request_options.connection_timeout)
    end

    # Performs a PUT request against the MercadoPago API.
    #
    # Serialises +data+ to JSON before sending.
    #
    # @param uri [String] API path (e.g. "/v1/payments/123")
    # @param data [Hash] request body (will be JSON-encoded)
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+
    # @raise [TypeError] if +data+ is not a Hash
    def _put(uri:, data:, request_options: nil)
      raise TypeError, 'Data must be a Hash' unless data.nil? || data.is_a?(Hash)

      request_options = _check_request_options(request_options)
      headers = _check_headers(request_options, { 'Content-Type': @config.mime_json })

      @http_client.put(url: @config.api_base_url + uri, data: data.to_json, headers: headers,
                       timeout: request_options.connection_timeout)
    end

    # Performs a DELETE request against the MercadoPago API.
    #
    # @param uri [String] API path (e.g. "/v1/customers/123")
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ (response may be nil)
    def _delete(uri:, request_options: nil)
      request_options = _check_request_options(request_options)
      headers = _check_headers(request_options)

      @http_client.delete(url: @config.api_base_url + uri, headers: headers,
                          timeout: request_options.connection_timeout)
    end
  end
end

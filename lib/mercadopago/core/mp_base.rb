# typed: false
# frozen_string_literal: true

module Mercadopago
  ##
  # Module Base
  class MPBase
    def initialize(request_options, http_client)
      unless request_options.is_a?(RequestOptions)
        raise TypeError,
              'Param request_options must be a RequestOptions object'
      end

      @request_options = request_options
      @http_client = http_client
      @config = Config.new
    end

    def _check_request_options(request_options = nil)
      request_options = @request_options if request_options.nil?
      unless request_options.is_a?(RequestOptions)
        raise TypeError,
              'Param request_options must be a RequestOptions object'
      end

      request_options.access_token = @request_options.access_token if request_options.access_token.nil?

      request_options
    end

    def _check_headers(request_options = nil, extra_headers = nil)
      headers = request_options.nil? ? @request_options.get_headers : request_options.get_headers

      headers.merge!(extra_headers) unless extra_headers.nil?

      headers
    end

    def _get(uri:, filters: nil, request_options: nil)
      raise TypeError, 'Filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      request_options = _check_request_options(request_options)
      headers = _check_headers(request_options)

      @http_client.get(url: @config.api_base_url + uri, headers: headers, params: filters,
                       timeout: request_options.connection_timeout, maxretries: request_options.max_retries)
    end

    def _post(uri:, data:, request_options: nil)
      raise TypeError, 'Data must be a Hash' unless data.nil? || data.is_a?(Hash)

      request_options = _check_request_options(request_options)
      headers = _check_headers(request_options, { 'Content-Type': @config.mime_json })
      payload = data&.to_json

      @http_client.post(url: @config.api_base_url + uri, data: payload, headers: headers, timeout: request_options.connection_timeout)
    end

    def _put(uri:, data:, request_options: nil)
      raise TypeError, 'Data must be a Hash' unless data.nil? || data.is_a?(Hash)

      request_options = _check_request_options(request_options)
      headers = _check_headers(request_options, { 'Content-Type': @config.mime_json })

      @http_client.put(url: @config.api_base_url + uri, data: data.to_json, headers: headers,
                       timeout: request_options.connection_timeout)
    end

    def _delete(uri:, request_options: nil)
      request_options = _check_request_options(request_options)
      headers = _check_headers(request_options)

      @http_client.delete(url: @config.api_base_url + uri, headers: headers,
                          timeout: request_options.connection_timeout)
    end
  end
end

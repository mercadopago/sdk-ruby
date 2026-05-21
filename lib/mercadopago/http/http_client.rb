# typed: false
# frozen_string_literal: true

require 'faraday'
require 'json'

module Mercadopago
  # Low-level HTTP transport layer built on top of RestClient.
  #
  # Provides the four standard HTTP verbs (GET, POST, PUT, DELETE) and
  # normalises every response into a +{ status:, response: }+ hash.
  # GET requests include automatic retry with a 1-second back-off for
  # transient errors (429, 500, 502, 503, 504).
  #
  # This class is used internally by {MPBase}. You can subclass or
  # replace it via +SDK.new(token, http_client: MyClient.new)+ to
  # inject a custom transport (e.g. for testing or logging).
  class HttpClient
    
    RETRYABLE_STATUSES = [429, 500, 502, 503, 504].freeze

    # Performs an HTTP GET request with automatic retry on transient errors.
    #
    # Retries up to +maxretries+ times with a 1-second sleep between
    # attempts when the server responds with 429 or 5xx status codes.
    #
    # @param url [String] fully qualified URL
    # @param headers [Hash] HTTP headers (query params can be nested under +:params+)
    # @param params [Hash, nil] query-string parameters appended to the URL
    # @param timeout [Float, nil] request timeout in seconds
    # @param maxretries [Integer, nil] maximum number of retry attempts
    # @return [Hash{Symbol => Object}] +:status+ (Integer HTTP code) and +:response+ (parsed JSON body)
    def get(url:, headers:, params: nil, timeout: nil, maxretries: nil)
      try = 0
      max = maxretries.to_i

      loop do
        response = execute(:get, url, headers: headers, params: params, timeout: timeout)
        return build_result(response) unless RETRYABLE_STATUSES.include?(response.status) && try < max - 1

        try += 1
        sleep(1)
      end
    end

    # Performs an HTTP POST request.
    #
    # @param url [String] fully qualified URL
    # @param data [String, nil] JSON-encoded request body
    # @param headers [Hash] HTTP headers (should include Content-Type)
    # @param timeout [Float, nil] request timeout in seconds
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ (parsed JSON body)
    def post(url:, data:, headers:, timeout: nil)
      build_result(execute(:post, url, headers: headers, body: data, timeout: timeout))
    end

    # Performs an HTTP PUT request.
    #
    # @param url [String] fully qualified URL
    # @param data [String, nil] JSON-encoded request body
    # @param headers [Hash] HTTP headers (should include Content-Type)
    # @param timeout [Float, nil] request timeout in seconds
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ (parsed JSON body)
    def put(url:, data:, headers:, timeout: nil)
      build_result(execute(:put, url, headers: headers, body: data, timeout: timeout))
    end

    # Performs an HTTP DELETE request.
    #
    # Returns +nil+ as the response body when the server sends an empty body,
    # which is common for successful deletions (204-style responses).
    #
    # @param url [String] fully qualified URL
    # @param headers [Hash] HTTP headers
    # @param timeout [Float, nil] request timeout in seconds
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ (parsed JSON body or nil)
    def delete(url:, headers:, timeout: nil)
      build_result(execute(:delete, url, headers: headers, timeout: timeout), allow_empty: true)
    end

    private

    def execute(method, url, headers:, params: nil, body: nil, timeout: nil)
      conn = Faraday.new(request: timeout ? { timeout: timeout } : {})
      conn.public_send(method, url) do |req|
        req.headers.update(stringify_keys(headers)) if headers && !headers.empty?
        req.params.update(params) if params
        req.body = body if body
      end
    end

    def build_result(response, allow_empty: false)
      body = response.body
      parsed = if allow_empty && (body.nil? || body.to_s.strip.empty?)
                 nil
               else
                 JSON.parse(body)
               end
      { status: response.status, response: parsed }
    end

    def stringify_keys(headers)
      headers.transform_keys(&:to_s)
    end
  end
end

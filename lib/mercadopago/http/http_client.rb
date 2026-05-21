# typed: false
# frozen_string_literal: true

require 'rest-client'
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
      headers = {} if headers.nil?
      headers[:params] = params unless params.nil?

      begin
        result = RestClient::Request.execute(method: :get, url: url, headers: headers, timeout: timeout)
        {
          status: result.code,
          response: JSON.parse(result.body)
        }
      rescue RestClient::Exception => e
        try += 1
        if [429, 500, 502, 503, 504].include?(e.http_code) && (try < maxretries)
          sleep(1)
          retry
        end
        {
          status: e.http_code,
          response: JSON.parse(e.response.body)
        }
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
      result = RestClient::Request.execute(method: :post, url: url, payload: data, headers: headers,
                                           timeout: timeout)
      {
        status: result.code,
        response: JSON.parse(result.body)
      }
    rescue RestClient::Exception => e
      {
        status: e.http_code,
        response: JSON.parse(e.response.body)
      }
    end

    # Performs an HTTP PUT request.
    #
    # @param url [String] fully qualified URL
    # @param data [String, nil] JSON-encoded request body
    # @param headers [Hash] HTTP headers (should include Content-Type)
    # @param timeout [Float, nil] request timeout in seconds
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ (parsed JSON body)
    def put(url:, data:, headers:, timeout: nil)
      result = RestClient::Request.execute(method: :put, url: url, payload: data, headers: headers,
                                           timeout: timeout)
      {
        status: result.code,
        response: JSON.parse(result.body)
      }
    rescue RestClient::Exception => e
      {
        status: e.http_code,
        response: JSON.parse(e.response.body)
      }
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
      result = RestClient::Request.execute(method: 'delete', url: url, headers: headers, timeout: timeout)
      {
        status: result.code,
        response: result.body.is_a?(String) && !result.body.strip.empty? ? JSON.parse(result.body) : nil
      }
    rescue RestClient::Exception => e
      {
        status: e.http_code,
        response: JSON.parse(e.response.body)
      }
    end
  end
end

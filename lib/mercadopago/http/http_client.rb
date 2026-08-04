# typed: false
# frozen_string_literal: true

require 'faraday'
require 'json'
require 'securerandom'

module Mercadopago
  # Low-level HTTP transport layer built on top of Faraday.
  class HttpClient
    RETRYABLE_STATUSES  = RequestOptions::DEFAULT_RETRY_ON.freeze
    DEFAULT_INITIAL_MS  = 1000
    DEFAULT_MAX_DELAY_MS = RequestOptions::DEFAULT_MAX_DELAY

    # GET with configurable retry + exponential backoff + jitter
    def get(url:, headers:, params: nil, timeout: nil, maxretries: nil,
            retry_on: nil, initial_delay_ms: nil, max_delay_ms: nil,
            jitter: false, on_retry: nil)
      with_retry(url: url, method: :get, headers: headers, params: params,
                 timeout: timeout, maxretries: maxretries, retry_on: retry_on,
                 initial_delay_ms: initial_delay_ms, max_delay_ms: max_delay_ms,
                 jitter: jitter, on_retry: on_retry)
    end

    def post(url:, data:, headers:, timeout: nil)
      build_result(execute(:post, url, headers: headers, body: data, timeout: timeout))
    end

    def put(url:, data:, headers:, timeout: nil)
      build_result(execute(:put, url, headers: headers, body: data, timeout: timeout))
    end

    def delete(url:, headers:, timeout: nil)
      build_result(execute(:delete, url, headers: headers, timeout: timeout), allow_empty: true)
    end

    private

    def with_retry(url:, method:, headers:, params: nil, body: nil, timeout: nil,
                   maxretries: nil, retry_on: nil, initial_delay_ms: nil,
                   max_delay_ms: nil, jitter: false, on_retry: nil)
      effective_retry_on   = retry_on || RETRYABLE_STATUSES
      effective_max        = (maxretries || 0).to_i
      effective_initial_ms = (initial_delay_ms || DEFAULT_INITIAL_MS).to_i
      effective_max_delay  = (max_delay_ms || DEFAULT_MAX_DELAY_MS).to_i

      attempt = 0
      loop do
        response = execute(method, url, headers: headers, params: params, body: body, timeout: timeout)
        result   = build_result(response)

        return result unless effective_retry_on.include?(response.status) && attempt < effective_max

        on_retry&.call(attempt + 1, nil)

        delay_ms = compute_delay(attempt, effective_initial_ms, effective_max_delay, jitter)
        sleep(delay_ms / 1000.0)
        attempt += 1
      end
    end

    def compute_delay(attempt, initial_ms, max_delay_ms, use_jitter)
      exponential = [initial_ms * (2**attempt), max_delay_ms].min
      return exponential unless use_jitter && exponential > 0

      # Use SecureRandom — NEVER rand() for security-relevant randomness
      SecureRandom.random_number(exponential + 1)
    end

    def execute(method, url, headers:, params: nil, body: nil, timeout: nil)
      conn = Faraday.new(request: timeout ? { timeout: timeout } : {})
      conn.public_send(method, url) do |req|
        req.headers.update(stringify_keys(headers)) if headers && !headers.empty?
        req.params.update(params) if params
        req.body = body if body
      end
    end

    def build_result(response, allow_empty: false)
      body   = response.body
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

# typed: false
# frozen_string_literal: true

require 'faraday'
require 'json'

module Mercadopago
  class HttpClient
    RETRYABLE_STATUSES = [429, 500, 502, 503, 504].freeze

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

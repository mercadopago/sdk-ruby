# typed: false
# frozen_string_literal: true

require 'rest-client'
require 'json'

module Mercadopago
  class HttpClient
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

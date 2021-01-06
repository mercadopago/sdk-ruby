# frozen_string_literal: true

require 'rest-client'
require 'json'

module Mercadopago
  class HttpClient
    def get(url, headers, filters = nil, timeout = nil, maxretries = nil)
      try = 0
      begin
        result = RestClient::Request.execute(method: :get, url: url, params: filters, headers: headers,
                                             timeout: timeout)
        response = {
          status: result.code,
          response: JSON.parse(result.body)
        }
      rescue RestClient::Exception => e
        try += 1
        retry if [429, 500, 502, 503, 504].include?(e.http_code) && (try < maxretries)
        response = {
          status: e.http_code,
          response: JSON.parse(e.response.body)
        }
      end
    end

    def post(url, data, headers, params = nil, timeout = nil, _maxretries = nil)
      result = RestClient::Request.execute(method: :post, url: url, payload: data, headers: headers,
                                           params: params, timeout: timeout)
      response = {
        status: result.code,
        response: JSON.parse(result.body)
      }
    rescue RestClient::Exception => e
      response = {
        status: e.http_code,
        response: JSON.parse(e.response.body)
      }
    end

    def put(url, data, headers, params = nil, timeout = nil, _maxretries = nil)
      result = RestClient::Request.execute(method: :put, url: url, payload: data, headers: headers,
                                           params: params, timeout: timeout)
      response = {
        status: result.code,
        response: JSON.parse(result.body)
      }
    rescue RestClient::Exception => e
      response = {
        status: e.http_code,
        response: JSON.parse(e.response.body)
      }
    end

    def delete(url, headers, params = nil, timeout = nil, _maxretries = nil)
      result = RestClient::Request.execute(method: 'delete', url: url, headers: headers, params: params,
                                           timeout: timeout)
      response = {
        status: result.code,
        response: JSON.parse(result.body)
      }
    rescue RestClient::Exception => e
      response = {
        status: e.http_code,
        response: JSON.parse(e.response.body)
      }
    end
  end
end

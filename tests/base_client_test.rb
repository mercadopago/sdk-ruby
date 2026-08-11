# typed: true
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/mercadopago'

class MockHttpClient < Mercadopago::HttpClient
  attr_reader :last_call

  def initialize
    # do NOT call super — skip real Faraday setup
  end

  def mock_response(response)
    @mock_response = response
  end

  def get(**_kwargs)
    @last_call = :get
    @mock_response
  end

  def post(**_kwargs)
    @last_call = :post
    @mock_response
  end

  def put(**_kwargs)
    @last_call = :put
    @mock_response
  end

  def delete(**_kwargs)
    @last_call = :delete
    @mock_response
  end
end

class BaseClientTest < Minitest::Test
  def setup
    @mock_http = MockHttpClient.new
    @sdk = Mercadopago::SDK.new('TEST_TOKEN', http_client: @mock_http)
  end

  def mock_response(hash)
    @mock_http.mock_response(hash)
  end
end

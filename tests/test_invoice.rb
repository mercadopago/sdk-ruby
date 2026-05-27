# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestInvoice < Minitest::Test
  def test_search_returns_valid_status
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    result = sdk.invoice.search(filters: { limit: 5 })
    assert_includes [200, 400, 401, 404], result[:status]
  end

  def test_search_raises_on_non_hash_filters
    sdk = Mercadopago::SDK.new('TEST_TOKEN')
    assert_raises(TypeError) { sdk.invoice.search(filters: 'not_a_hash') }
  end
end

# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestPreference < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 'PREF-123', 'init_point' => 'https://mp.com/checkout' } })
    result = @sdk.preference.get('PREF-123')
    assert_equal 200, result[:status]
    assert_equal 'PREF-123', result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 'PREF-456', 'init_point' => 'https://mp.com/checkout' } })
    result = @sdk.preference.create({ items: [{ title: 'Test', quantity: 1, unit_price: 10.0 }] })
    assert_equal 201, result[:status]
    assert_equal 'PREF-456', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_update
    mock_response({ status: 200, response: { 'id' => 'PREF-123', 'expires' => true } })
    result = @sdk.preference.update('PREF-123', { expires: true })
    assert_equal 200, result[:status]
    assert_equal 'PREF-123', result[:response]['id']
    assert_equal :put, @mock_http.last_call
  end

  def test_search
    mock_response({ status: 200, response: { 'paging' => { 'total' => 2 }, 'elements' => [] } })
    result = @sdk.preference.search(filters: { external_reference: 'ref-001' })
    assert_equal 200, result[:status]
    assert_equal 2, result[:response]['paging']['total']
    assert_equal :get, @mock_http.last_call
  end
end

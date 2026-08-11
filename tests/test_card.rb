# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestCard < BaseClientTest
  def test_list
    mock_response({ status: 200, response: [{ 'id' => 'CARD-1' }, { 'id' => 'CARD-2' }] })
    result = @sdk.card.list('CUST-123')
    assert_equal 200, result[:status]
    assert_equal 2, result[:response].size
    assert_equal :get, @mock_http.last_call
  end

  def test_get
    mock_response({ status: 200, response: { 'id' => 'CARD-1', 'last_four_digits' => '4321' } })
    result = @sdk.card.get('CUST-123', 'CARD-1')
    assert_equal 200, result[:status]
    assert_equal 'CARD-1', result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 'CARD-99', 'last_four_digits' => '1234' } })
    result = @sdk.card.create('CUST-123', { token: 'tok_abc123' })
    assert_equal 201, result[:status]
    assert_equal 'CARD-99', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_update
    mock_response({ status: 200, response: { 'id' => 'CARD-1', 'expiration_year' => 2030 } })
    result = @sdk.card.update('CUST-123', 'CARD-1', { expiration_year: 2030 })
    assert_equal 200, result[:status]
    assert_equal 2030, result[:response]['expiration_year']
    assert_equal :put, @mock_http.last_call
  end

  def test_delete
    mock_response({ status: 200, response: { 'id' => 'CARD-1' } })
    result = @sdk.card.delete('CUST-123', 'CARD-1')
    assert_equal 200, result[:status]
    assert_equal :delete, @mock_http.last_call
  end
end

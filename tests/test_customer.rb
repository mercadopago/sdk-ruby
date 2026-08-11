# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestCustomer < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 'CUST-123', 'email' => 'test@test.com' } })
    result = @sdk.customer.get('CUST-123')
    assert_equal 200, result[:status]
    assert_equal 'CUST-123', result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 'CUST-456', 'email' => 'new@test.com' } })
    result = @sdk.customer.create({ email: 'new@test.com' })
    assert_equal 201, result[:status]
    assert_equal 'CUST-456', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_update
    mock_response({ status: 200, response: { 'id' => 'CUST-123', 'first_name' => 'John' } })
    result = @sdk.customer.update('CUST-123', { first_name: 'John' })
    assert_equal 200, result[:status]
    assert_equal 'John', result[:response]['first_name']
    assert_equal :put, @mock_http.last_call
  end

  def test_delete
    mock_response({ status: 200, response: { 'id' => 'CUST-123' } })
    result = @sdk.customer.delete('CUST-123')
    assert_equal 200, result[:status]
    assert_equal :delete, @mock_http.last_call
  end

  def test_search
    mock_response({ status: 200, response: { 'paging' => { 'total' => 1 }, 'results' => [{ 'id' => 'CUST-123' }] } })
    result = @sdk.customer.search(filters: { email: 'test@test.com' })
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['paging']['total']
    assert_equal :get, @mock_http.last_call
  end

  def test_search_auto_paging_iter_returns_iterator
    iterator = @sdk.customer.search_auto_paging_iter(filters: { email: 'test@test.com' })
    assert_respond_to iterator, :each
  end
end

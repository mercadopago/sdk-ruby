# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestOrder < BaseClientTest
  def test_create
    mock_response({ status: 201, response: { 'id' => 'ORD-123', 'status' => 'opened' } })
    result = @sdk.order.create({ type: 'online', processing_mode: 'automatic',
                                 total_amount: '100.00', payer: { email: 'test@test.com' } })
    assert_equal 201, result[:status]
    assert_equal 'ORD-123', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_get
    mock_response({ status: 200, response: { 'id' => 'ORD-123', 'status' => 'opened' } })
    result = @sdk.order.get('ORD-123')
    assert_equal 200, result[:status]
    assert_equal 'ORD-123', result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_process
    mock_response({ status: 200, response: { 'id' => 'ORD-123', 'status' => 'processed' } })
    result = @sdk.order.process('ORD-123')
    assert_equal 200, result[:status]
    assert_equal 'processed', result[:response]['status']
    assert_equal :post, @mock_http.last_call
  end

  def test_cancel
    mock_response({ status: 200, response: { 'id' => 'ORD-123', 'status' => 'cancelled' } })
    result = @sdk.order.cancel('ORD-123')
    assert_equal 200, result[:status]
    assert_equal 'cancelled', result[:response]['status']
    assert_equal :post, @mock_http.last_call
  end

  def test_capture
    mock_response({ status: 200, response: { 'id' => 'ORD-123', 'status' => 'captured' } })
    result = @sdk.order.capture('ORD-123')
    assert_equal 200, result[:status]
    assert_equal 'captured', result[:response]['status']
    assert_equal :post, @mock_http.last_call
  end

  def test_refund
    mock_response({ status: 201, response: { 'id' => 'REF-001', 'status' => 'approved' } })
    result = @sdk.order.refund('ORD-123')
    assert_equal 201, result[:status]
    assert_equal 'REF-001', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_search
    mock_response({ status: 200, response: { 'elements' => [{ 'id' => 'ORD-123' }] } })
    result = @sdk.order.search(filters: { external_reference: 'ref-001' })
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['elements'].size
    assert_equal :get, @mock_http.last_call
  end

  def test_create_checkout_pro
    mock_response({ status: 201, response: { 'id' => 'ORD-456', 'type' => 'online',
                                             'processing_mode' => 'manual' } })
    result = @sdk.order.create_checkout_pro({ total_amount: '200.00',
                                              payer: { email: 'buyer@test.com' } })
    assert_equal 201, result[:status]
    assert_equal 'ORD-456', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_create_checkout_pro_raises_on_wrong_type
    assert_raises(ArgumentError) do
      @sdk.order.create_checkout_pro({ type: 'offline', total_amount: '100.00' })
    end
  end

  def test_create_checkout_pro_raises_on_wrong_processing_mode
    assert_raises(ArgumentError) do
      @sdk.order.create_checkout_pro({ processing_mode: 'automatic', total_amount: '100.00' })
    end
  end
end

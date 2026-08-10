# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestPoint < BaseClientTest
  def test_get_devices
    mock_response({ status: 200, response: { 'devices' => [{ 'id' => 'DEVICE-001', 'status' => 'AVAILABLE' }] } })
    result = @sdk.point.get_devices
    assert_equal 200, result[:status]
    assert_equal 1, result[:response]['devices'].size
    assert_equal 'DEVICE-001', result[:response]['devices'].first['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 'PI-001', 'state' => 'OPEN', 'device_id' => 'DEVICE-001' } })
    result = @sdk.point.create('DEVICE-001', { amount: 100, description: 'Test payment', payment: { installments: 1 } })
    assert_equal 201, result[:status]
    assert_equal 'PI-001', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end

  def test_get
    mock_response({ status: 200, response: { 'id' => 'PI-001', 'state' => 'FINISHED' } })
    result = @sdk.point.get('PI-001')
    assert_equal 200, result[:status]
    assert_equal 'PI-001', result[:response]['id']
    assert_equal 'FINISHED', result[:response]['state']
    assert_equal :get, @mock_http.last_call
  end

  def test_cancel
    mock_response({ status: 200, response: { 'id' => 'PI-001', 'state' => 'CANCELLED' } })
    result = @sdk.point.cancel('DEVICE-001', 'PI-001')
    assert_equal 200, result[:status]
    assert_equal :delete, @mock_http.last_call
  end
end

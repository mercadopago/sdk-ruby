# typed: true
# frozen_string_literal: true

require_relative 'base_client_test'

class TestCardToken < BaseClientTest
  def test_get
    mock_response({ status: 200, response: { 'id' => 'tok_abc123', 'last_four_digits' => '6351' } })
    result = @sdk.card_token.get('tok_abc123')
    assert_equal 200, result[:status]
    assert_equal 'tok_abc123', result[:response]['id']
    assert_equal :get, @mock_http.last_call
  end

  def test_create
    mock_response({ status: 201, response: { 'id' => 'tok_new456', 'last_four_digits' => '6351' } })
    result = @sdk.card_token.create({
                                      card_number: '5031433215406351',
                                      expiration_year: 2030,
                                      expiration_month: 11,
                                      security_code: '123',
                                      cardholder: { name: 'APRO' }
                                    })
    assert_equal 201, result[:status]
    assert_equal 'tok_new456', result[:response]['id']
    assert_equal :post, @mock_http.last_call
  end
end

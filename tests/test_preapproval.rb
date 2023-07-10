# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPreapproval < Minitest::Test
  def setup
    @card_token_object = {
      card_number: '5031433215406351',
      expiration_year: 2025,
      expiration_month: 11,
      security_code: '123',
      cardholder: {
        name: 'APRO'
      }
    }
  end

  def test_method_search
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    create_response = create_preapproval(sdk)
    assert_equal 201, create_response[:status]

    result = sdk.preapproval.search(filters: { id: create_response[:response]['id'] })
    assert_equal 200, result[:status]
  end

  def test_method_get_id
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    create_response = create_preapproval(sdk)
    assert_equal 201, create_response[:status]

    result = sdk.preapproval.get(create_response[:response]['id'])
    assert_equal 200, result[:status]
  end

  def test_method_post
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    result = create_preapproval(sdk)
    assert_equal 201, result[:status]
  end

  def test_method_put
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    create_response = create_preapproval(sdk)
    assert_equal 201, create_response[:status]

    update_data = {
      reason: 'Yoga classes',
      external_reference: 'YG-12345',
      payer_email: 'test_user@testuser.com',
      auto_recurring: {
        frequency: 2,
        frequency_type: 'months',
        transaction_amount: 15,
        currency_id: 'BRL'
      },
      back_url: 'https://www.mercadopago.com.ar',
      status: 'authorized'
    }
    result = sdk.preapproval.update(create_response[:response]['id'], update_data)
    assert_equal 200, result[:status]
  end

  def create_preapproval(sdk)
    result_card_token = sdk.card_token.create(@card_token_object)

    preapproval_data = {
      reason: 'Yoga classes',
      external_reference: 'YG-1234',
      payer_email: 'test_user@testuser.com',
      card_token_id: result_card_token[:response]['id'],
      auto_recurring: {
        frequency: 1,
        frequency_type: 'months',
        start_date: '2023-06-02T13:07:14.260Z',
        end_date: "2023-07-20T15:59:52.581Z",
        transaction_amount: 10,
        currency_id: 'BRL'
      },
      back_url: 'https://www.mercadopago.com.ar',
      status: 'authorized'
    }

    sdk.preapproval.create(preapproval_data)
  end
end

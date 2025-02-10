# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestCard < Minitest::Test
  def test_all
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    customer_object = {
      email: 'test_payer_999944@testuser.com',
      first_name: 'Rafa',
      last_name: 'Williner',
      phone: {
        area_code: '03492',
        number: '432334'
      },
      identification: {
        type: 'DNI',
        number: '29804555'
      },
      address: {
        street_name: 'some street'
      },
      description: 'customer description'
    }

    customer_saved = sdk.customer.create(customer_object)
    assert_equal 201, customer_saved[:status]
    customer_id = customer_saved[:response]['id']
    sleep(1)

    card_token_object = {
      card_number: '5031433215406351',
      expiration_year: 2030,
      expiration_month: 11,
      security_code: '123',
      cardholder: {
        name: 'APRO'
      }
    }

    begin
      card_token = sdk.card_token.create(card_token_object)

      card_object = {
        token: card_token[:response]['id']
      }

      card_saved = sdk.card.create(customer_id, card_object)
      assert !card_saved.nil?
      assert !card_saved[:response].nil?
      assert !card_saved[:response]['id'].nil?
      sleep(1)

      cards = sdk.card.list(customer_id)
      assert !cards.nil?
      assert !cards[:response].nil?
      assert !cards[:response].empty?
      sleep(1)

      card_get = sdk.card.get(customer_id, card_saved[:response]['id'])
      assert_equal 200, card_get[:status]
      sleep(1)

      card_deleted = sdk.card.delete(customer_id, card_saved[:response]['id'])
      assert_equal 200, card_deleted[:status]
      sleep(1)
    ensure
      if customer_saved.key?(:response) && customer_saved[:response].key?('id')
        customer_deleted = sdk.customer.delete(customer_saved[:response]['id'])
        assert_equal 200, customer_deleted[:status]
      end
    end
  end
end

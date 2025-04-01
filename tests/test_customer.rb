# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestCustomer < Minitest::Test
  def test_all
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    customer_object = {
      email: 'test_payer_9999SAE@testuser.com',
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
        zip_code: '26515069',
        street_name: 'some street',
        street_number: 123
      },
      description: 'customer description'
    }

    begin
      customer_saved = sdk.customer.create(customer_object)
      assert_equal 201, customer_saved[:status]
      sleep(1)

      customers = sdk.customer.search(filters: { email: 'test_payer_999922@testuser.com' })
      assert_equal 200, customers[:status]
      sleep(1)

      customer_update = sdk.customer.update(customer_saved[:response]['id'], { last_name: 'Payer' })
      assert_equal 200, customer_update[:status]
      sleep(1)

      customer_updated = sdk.customer.get(customer_saved[:response]['id'])
      assert_equal 'Payer', customer_updated[:response]['last_name']
      sleep(1)
    ensure
      if customer_saved.key?(:response) && customer_saved[:response].key?('id')
        customer_deleted = sdk.customer.delete(customer_saved[:response]['id'])
        assert_equal 200, customer_deleted[:status]
      end
    end
  end
end

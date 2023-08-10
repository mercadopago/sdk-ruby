# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestCustomer < Minitest::Test
  def test_all
    sdk = Mercadopago::SDK.new('TEST-783169576377080-082620-395ee7f82e0d55b1db606c118686c1db-464842924')

    customer_object = {
      email: 'test_payer_1999922@testuser.com',
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

    begin
      customer_saved = sdk.customer.create(customer_object)
      assert_equal 201, customer_saved[:status]

      customers = sdk.customer.search(filters: { email: 'test_payer_999922@testuser.com' })
      assert_equal 200, customers[:status]

      customer_update = sdk.customer.update(customer_saved[:response]['id'], { last_name: 'Payer' })
      assert_equal 200, customer_update[:status]

      customer_updated = sdk.customer.get(customer_saved[:response]['id'])
      assert_equal 'Payer', customer_updated[:response]['last_name']
    ensure
      if customer_saved.key?(:response) && customer_saved[:response].key?('id')
        customer_deleted = sdk.customer.delete(customer_saved[:response]['id'])
        assert_equal 200, customer_deleted[:status]
      end
    end
  end
end

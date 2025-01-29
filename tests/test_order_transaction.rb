# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestOrder < Minitest::Test

  def create_order_request
    {
      type: 'online',
      processing_mode: 'manual',
      total_amount: '1000.00',
      external_reference: 'ext_ref_1234',
      payer: {
        email: 'test_1731350184@testuser.com'
      }
    }
  end

  def test_create_transaction
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    order_request = create_order_request
    order_transaction_data = {
      payments: [{
        amount: '10.00',
        payment_method: {
          id: 'pix',
          type: 'bank_transfer'
        }
      }]
    }

    result = sdk.order.create(order_request)
    order_created = result[:response]
    assert_equal 201, result[:status]

    result_transaction = sdk.order_transaction.create(order_created['id'], order_transaction_data)
    assert_equal 201, result_transaction[:status]
  end
end

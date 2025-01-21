# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestOrder < Minitest::Test

  def test_create_order
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    order_request = {
      type: 'online',
      total_amount: '1000.00',
      external_reference: 'ext_ref_1234',
      transactions: {
        payments: [
          {
            amount: '1000.00',
            payment_method: {
              id: 'pix',
              type: 'bank_transfer',
            }
          }
        ]
      },
      payer: {
        email: 'test_1731350184@testuser.com'
      }
    }
    result = sdk.order.create(order_request)
    assert_equal 201, result[:status]
  end

end

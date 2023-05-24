# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPreapprovalPlan < Minitest::Test
  def test_method_search
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')
    result = sdk.preapproval_plan.search(filters: { id: '2c9380848848983b01884f8458d70324' })

    assert_equal 200, result[:status]
  end

  def test_method_get_id
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')
    result = sdk.preapproval_plan.get('2c9380848848983b01884f8458d70324')

    assert_equal 200, result[:status]
  end

  def test_method_post
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')

    preapproval_plan_data = {
      reason: 'Yoga classes',
      auto_recurring: {
        frequency: 1,
        frequency_type: 'months',
        repetitions: 12,
        billing_day: 10,
        billing_day_proportional: true,
        free_trial: {
          frequency: 1,
          frequency_type: 'months'
        },
        transaction_amount: 10,
        currency_id: 'BRL'
      },
      payment_methods_allowed: {
        payment_types: [
          {}
        ],
        payment_methods: [
          {}
        ]
      },
      back_url: 'https://www.yoursite.com'
    }
    
    result = sdk.preapproval_plan.create(preapproval_plan_data)
    assert_equal 201, result[:status]
  end

  def test_method_put
    sdk = Mercadopago::SDK.new('TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659')
    preapproval_plan_data = {
      reason: 'Pilates classes',
      auto_recurring: {
        frequency: 1,
        frequency_type: 'months',
        repetitions: 20,
        billing_day: 15,
        billing_day_proportional: true,
        free_trial: {
          frequency: 1,
          frequency_type: 'months'
        },
        transaction_amount: 10,
        currency_id: 'BRL'
      },
      payment_methods_allowed: {
        payment_types: [
          {}
        ],
        payment_methods: [
          {}
        ]
      },
      back_url: 'https://www.yoursite.com'
    }
    result = sdk.preapproval_plan.update('2c9380848848983b01884f8458d70324', preapproval_plan_data)
    assert_equal 200, result[:status]
  end
end

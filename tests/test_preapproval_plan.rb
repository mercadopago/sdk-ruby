# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPreapprovalPlan < Minitest::Test
  def setup
    @preapproval_plan_data = {
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
  end

  def test_method_search
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    result = sdk.preapproval_plan.create(@preapproval_plan_data)
    assert_equal 201, result[:status]

    result = sdk.preapproval_plan.search(filters: { id: result[:response]['id'] })
    assert_equal 200, result[:status]
  end

  def test_method_get_id
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    result = sdk.preapproval_plan.create(@preapproval_plan_data)
    assert_equal 201, result[:status]

    result = sdk.preapproval_plan.get(result[:response]['id'])
    assert_equal 200, result[:status]
  end

  def test_method_post
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])
    
    result = sdk.preapproval_plan.create(@preapproval_plan_data)
    assert_equal 201, result[:status]
  end

  def test_method_put
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    update_data = {
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

    result = sdk.preapproval_plan.create(@preapproval_plan_data)
    assert_equal 201, result[:status]

    result = sdk.preapproval_plan.update(result[:response]['id'], update_data)
    assert_equal 200, result[:status]
  end
end

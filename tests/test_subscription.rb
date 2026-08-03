# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'
require 'minitest/autorun'

class TestSubscription < Minitest::Test
  def test_method_search
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    create_response = create_subscription(sdk)
    assert_equal 201, create_response[:status]

    result = sdk.subscription.search(filters: { id: create_response[:response]['id'] })
    assert_equal 200, result[:status]
  end

  def test_method_get
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    create_response = create_subscription(sdk)
    assert_equal 201, create_response[:status]

    result = sdk.subscription.get(create_response[:response]['id'])
    assert_equal 200, result[:status]
    assert_equal create_response[:response]['id'], result[:response]['id']
  end

  def test_method_post
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    result = create_subscription(sdk)
    assert_equal 201, result[:status]
  end

  def test_method_update
    sdk = Mercadopago::SDK.new(ENV['ACCESS_TOKEN'])

    create_response = create_subscription(sdk)
    assert_equal 201, create_response[:status]

    update_data = { status: 'paused' }
    result = sdk.subscription.update(create_response[:response]['id'], update_data)
    assert_equal 200, result[:status]
  end

  def create_subscription(sdk)
    plan_data = {
      reason: 'Subscription plan test',
      auto_recurring: {
        frequency: 1,
        frequency_type: 'months',
        transaction_amount: 10,
        currency_id: 'BRL'
      },
      back_url: 'https://www.mercadopago.com.br',
      payment_methods_allowed: {
        payment_types: [{ id: 'credit_card' }]
      }
    }
    plan_response = sdk.preapproval_plan.create(plan_data)

    subscription_data = {
      preapproval_plan_id: plan_response[:response]['id'],
      payer_email: 'test_user_28355466@testuser.com',
      back_url: 'https://www.mercadopago.com.br'
    }
    sdk.subscription.create(subscription_data)
  end
end

# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestCard < Minitest::Test
  def test_method_get
    sdk = Mercadopago::SDK.new(access_token = 'APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966')

    # result = sdk.card.create(customer_id:"12", card_object:card_object)
  end
end

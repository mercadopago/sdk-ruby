require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestCard < Minitest::Test
    def test_method_get
        sdk = Mercadopago::SDK.new(access_token="APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966")
		sdk.request_options = Mercadopago::RequestOptions.new(corporation_id:"abc")
		#result = sdk.card().get(customer_id:"12", card_id:"6587")

        #assert_equal 200, result[:status]
	end
end

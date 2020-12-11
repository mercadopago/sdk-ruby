require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestUser < Minitest::Test
    def test_method_get
        sdk = Mercadopago::SDK.new(access_token="APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966")
        sdk.request_options = Mercadopago::RequestOptions.new(corporation_id:"abc")
        #simulando timeout:
		result = sdk.user().get(request_options:Mercadopago::RequestOptions.new(connection_timeout:0.0001))
        #result = sdk.user().get()

        assert_equal 200, result[:status]
	end
end

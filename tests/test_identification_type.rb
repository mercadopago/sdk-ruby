require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestIdentificationType < Minitest::Test
    def test_method_get
        sdk = Mercadopago::SDK.new(access_token="APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966")
		sdk.request_options = Mercadopago::RequestOptions.new(corporation_id:"abc")
		result = sdk.identification_type().get()

        assert_equal 200, result[:status]
	end
end

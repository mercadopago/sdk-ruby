$LOAD_PATH << '../lib'

require 'test/unit'
require 'webmock/test_unit'
require 'mercadopago'

WebMock.disable_net_connect!

class MercadoPagoTest < Test::Unit::TestCase
	ACCESS_TOKEN = 'abc123'
	API_HOST = 'https://api.mercadopago.com'

	DEFAULT_HEADERS = {
		'Accept' => 'application/json',
		'Content-Type' => 'application/json',
		'User-Agent' => 'MercadoPago Ruby SDK v0.3.5'
	}

	HEADERS_WWW_FORM = DEFAULT_HEADERS.merge(
		'Content-Type' => 'application/x-www-form-urlencoded'
	)

	def setup
		@mp = MercadoPago.new("CLIENT_ID", "CLIENT_SECRET")
		stub_token_generation!
	end

	def stub_token_generation!
		body = {'client_id'=>'CLIENT_ID', 'client_secret'=>'CLIENT_SECRET', 'grant_type'=>'client_credentials'}
		stub_request(:post, "#{API_HOST}/oauth/token")
			.with(body: body, headers: HEADERS_WWW_FORM)
			.to_return(status: 200, body: '{"access_token": "'+ACCESS_TOKEN+'"}')
	end

	def test_long_live_access_token
		@mp = MercadoPago.new("LONG_LIVE_ACCESS_TOKEN")

		assert_equal(@mp.get_access_token(), "LONG_LIVE_ACCESS_TOKEN")
	end

	# Create a new preference
	def test_create_preference
		preference_data = {'items' => ['title'=>'testCreate', 'quantity'=>1, 'unit_price'=>10.2, 'currency_id'=>'ARS']}
		expected_url = "#{API_HOST}/checkout/preferences?access_token=#{ACCESS_TOKEN}"

		stub_request(:post, expected_url)
			.with(body: preference_data, headers: DEFAULT_HEADERS)
			.to_return(status: 201, body: '{"created": true}')

		preference = @mp.create_preference(preference_data)

		assert_requested(:post, expected_url, times: 1)

		assert_equal(preference['status'], '201')
	end

	# Obtain a preference given ID
	def test_get_preference
		preference_id = "123456ID"

		expected_url = "#{API_HOST}/checkout/preferences/#{preference_id}?access_token=#{ACCESS_TOKEN}"

		stub_request(:get, expected_url)
			.with(headers: DEFAULT_HEADERS)
			.to_return(status: 200, body: '{"preferences": []}')

		preference = @mp.get_preference(preference_id);

		assert_requested(:get, expected_url, times: 1)

		assert_equal(preference['status'], '200')
	end

	# Update preference given ID and preference body
	def test_update_preference
		preference_id = "123456ID"
		preference_data = {'items' => ['title'=>'testCreate', 'quantity'=>1, 'unit_price'=>10.2, 'currency_id'=>'ARS']}

		expected_url = "#{API_HOST}/checkout/preferences/#{preference_id}?access_token=#{ACCESS_TOKEN}"

		stub_request(:put, expected_url)
			.with(body: preference_data, headers: DEFAULT_HEADERS)
			.to_return(status: 200, body: '{"preferences": []}')

		preference = @mp.update_preference(preference_id, preference_data);

		assert_requested(:put, expected_url, times: 1)

		assert_equal(preference['status'], '200')
	end
end

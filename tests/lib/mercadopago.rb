$LOAD_PATH << '../../lib'

require 'webmock/test_unit'
require 'test/unit'
require 'mercadopago'
require 'logger'
require 'pry'

WebMock.disable_net_connect!

class MercadoPagoTest < Test::Unit::TestCase
	API_HOST = 'https://api.mercadopago.com'

	def setup
		@mp = MercadoPago.new("CLIENT_ID", "CLIENT_SECRET")
		stub_token_generation
	end

	def stub_token_generation
		stub_request(:post, "#{API_HOST}/oauth/token").
		with(body: {"client_id"=>"CLIENT_ID", "client_secret"=>"CLIENT_SECRET", "grant_type"=>"client_credentials"},
				 headers: {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'MercadoPago Ruby SDK v0.3.5'}).
		to_return(status: 200, body: '{"access_token": "abc123", "status": 200}')
	end

	def test_search_customer
		url_expected = "#{API_HOST}/v1/customers/search?access_token=abc123&last_name=Adams&limit=10&metadata.user_nickname&name=Douglas&offset=20&properties.other&properties.same"

		stub_request(:get, url_expected)
			.with(headers: {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'User-Agent'=>'MercadoPago Ruby SDK v0.3.5'})
			.to_return(status: 200, body: '{"results": []}')

		filters = {
			name: 'Douglas',
			last_name: 'Adams',
			metadata: {
				user_nickname: 'Rodic',
				properties: {
					same: 'key',
					other: 'key'
				}
			}
		}

		response = @mp.search_customer(filters, 20, 10)

		assert_requested(:get, url_expected, times: 1)
		assert_equal(response['response'], {"results"=>[]})
	end
end

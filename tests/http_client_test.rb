
require 'minitest/autorun'
require_relative '../mercadopago/http/http'

class HttpClientTeste < Minitest::Test
    def test_method_get
        params = {access_token: 'TEST-6741486419215567-061217-ac9e5283c87741ca74e4ac49d07c9928-167842516', id: '167842516-71f7dc91-eb77-4ed7-b3a7-a410fc0e940d'}
        url = "https://api.mercadopago.com/checkout/preferences/"
        result = HttpClient.new.get(url, params)
        assert_equal 200, result[:status]
	end
end
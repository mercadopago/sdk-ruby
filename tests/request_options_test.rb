require 'minitest/autorun'
require_relative '../mercadopago/core/request_options'


class RequestOptionsTest < Minitest::Test

	def test
        assert_equal nil, RequestOptions.new()
	end
end
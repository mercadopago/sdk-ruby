require 'minitest/autorun'
require_relative '../mercadopago/core/mp_base'

include MpBase
include SDK

class MpBaseTest < Minitest::Test

    def test_get_mp_base
        SDK::init_token('TEST-6741486419215567-061217-ac9e5283c87741ca74e4ac49d07c9928-167842516')
       
        uri = "/checkout/preferences/167842516-71f7dc91-eb77-4ed7-b3a7-a410fc0e940d"
        mp_base = MpBase::get_(uri, "nil")
        assert_equal 200,  mp_base[:status]
	end
end
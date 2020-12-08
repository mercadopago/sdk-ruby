require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPreference < Minitest::Test
    
    def test_method_get
       sdk = Mercadopago::SDK.new(access_token="TEST-783169576377080-082620-395ee7f82e0d55b1db606c118686c1db-464842924")
		result = sdk.preference().get()
        assert_equal 200, result[:status]
    end

    def test_method_get_id
        sdk = Mercadopago::SDK.new(access_token="TEST-783169576377080-082620-395ee7f82e0d55b1db606c118686c1db-464842924")
        result = sdk.preference().get(preference_id="464842924-68bdeddf-5642-44ef-853c-e0d4df3a63f1")
        assert_equal 200, result[:status]
    end
    
    def test_method_post
       sdk = Mercadopago::SDK.new(access_token="TEST-783169576377080-082620-395ee7f82e0d55b1db606c118686c1db-464842924")
       data = {
        "items": [
            {
            "title": "Dummy Item",
            "description": "Multicolor Item",
            "quantity": 1,
            "currency_id": "",
            "unit_price": 10.0
            }
         ]
      }
       result = sdk.preference().post(data)
       assert_equal 201, result[:status]
    end

    def test_method_put
       sdk = Mercadopago::SDK.new(access_token="TEST-783169576377080-082620-395ee7f82e0d55b1db606c118686c1db-464842924")
       data = {
             "items": [
                {
                "title": "Dummy Item",
                "description": "Multicolor Item",
                "quantity": 1,
                "currency_id": "",
                "unit_price": 10.0
                }
            ]
         }
        result = sdk.preference().put(preference_id="464842924-68bdeddf-5642-44ef-853c-e0d4df3a63f1", data)
        assert_equal 200, result[:status]
    end
end
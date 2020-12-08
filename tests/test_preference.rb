require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPreference < Minitest::Test
    
    def test_method_get
       sdk = Mercadopago::SDK.new(access_token="APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966")
		result = sdk.preference().get()
        assert_equal 200, result[:status]
    end
    
    def test_method_post
       sdk = Mercadopago::SDK.new(access_token="APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966")
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
        sdk = Mercadopago::SDK.new(access_token="APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966")
        data = {
         "items": [
             {
             "title": "Dummy Items",
             "description": "Barcelona Items",
             "quantity": 1,
             "currency_id": "",
             "unit_price": 10.0
             }
          ]
       }
        result = sdk.preference().put(data)
        assert_equal 201, result[:status]
     end
    

end
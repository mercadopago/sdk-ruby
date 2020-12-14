require_relative '../lib/mercadopago'

require 'minitest/autorun'

class CardToken < Minitest::Test
     
   def test_method_get_id
      sdk = Mercadopago::SDK.new(access_token="TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659")
      result = sdk.card_token().get(card_token_id="fbd3595d258f1624e84e4f1a995e0f8f")
      assert_equal 200, result[:status]
  end

    def test_method_post
       sdk = Mercadopago::SDK.new(access_token="TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659")
       data = {
        "card_number": "4235647728025682",
        "expiration_year": 2025,
        "expiration_month": 11,
        "security_code": "123",
        "cardholder": {
            "name": "APRO"
    
        }
     }
       result = sdk.card_token().create(data)
       assert_equal 201, result[:status]
    end
 end
require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPayment < Minitest::Test
    
    def test_method_search
        sdk = Mercadopago::SDK.new(access_token="TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659")
		result = sdk.payment().search({"id"=>1231872196})
        assert_equal 200, result[:status]
    end

    def test_method_get_id
        sdk = Mercadopago::SDK.new(access_token="TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659")
        result = sdk.payment().get(payment_id=1231872196)
        assert_equal 200, result[:status]
    end
    
    def test_method_post 
        sdk = Mercadopago::SDK.new(access_token="APP_USR-558881221729581-091712-44fdc612e60e3e638775d8b4003edd51-471763966")
        card_token_object = {
            "card_number": "4235647728025682",
            "expiration_year": 2025,
            "expiration_month": 11,
            "security_code": "123",
            "cardholder": {
               "name": "APRO" 
            }
         }
        result_card_token = sdk.card_token().create(card_token_object)
   
        payment_object = {
        "token": result_card_token[:response]['id'],
        "installments": 1,
        "transaction_amount": 58.80,
        "description": "Point Mini a maquininha que dá o dinheiro de suas vendas na hora",
        "payment_method_id": "visa",
        "payer": {
            "email": "test_user_123456@testuser.com",
            "identification": {
                "number": "19119119100",
                "type": "CPF"
            }
        },
        "notification_url": "https://www.suaurl.com/notificacoes/",
        "binary_mode": false,
        "external_reference": "MP0001",
        "statement_descriptor": "MercadoPago",
        "additional_info": {
            "items": [{
                "id": "PR0001",
                "title": "Point Mini",
                "description": "Producto Point para cobros con tarjetas mediante bluetooth",
                "picture_url": "https://http2.mlstatic.com/resources/frontend/statics/growth-sellers-landings/device-mlb-point-i_medium@2x.png",
                "category_id": "electronics",
                "quantity": 1,
                "unit_price": 58.80
            }],
            "payer": {
                "first_name": "Nome",
                "last_name": "Sobrenome",
                "address": {
                    "zip_code": "06233-200",
                    "street_name": "Av das Nacoes Unidas",
                    "street_number": 3003
                },
                "registration_date": "2019-01-01T12:01:01.000-03:00",
                "phone": {
                    "area_code": "011",
                    "number": "987654321"
                }
            },
            "shipments": {
                "receiver_address": {
                    "street_name": "Av das Nacoes Unidas",
                    "street_number": 3003,
                    "zip_code": "06233200",
                    "city_name": "Buzios",
                    "state_name": "Rio de Janeiro"
                }
            }
        }
    }
      result = sdk.payment().create(payment_object)
      assert_equal 201, result[:status]
    end

    def test_method_put
        sdk = Mercadopago::SDK.new(access_token="TEST-6130770563612470-121314-d27bbd7363e64c3853f058251cf8fc6e-537031659")
        data = {
            "status": "approved",
        }
        result = sdk.payment().update(payment_id="1231910402", data)
        assert_equal 403, result[:status]
    end
 end
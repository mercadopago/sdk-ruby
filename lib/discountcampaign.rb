
require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'
require 'mercadopagorestclient'

class DiscountCampaign < MercadoPagoRestClient
	def initialize(client_id, client_secret, access_token)
		super(client_id, client_secret, access_token)
    end

	def get(transaction_amount, payer_email, coupon_code)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
        end
        
        filters["transaction_amount"] = transaction_amount
		filters["payer_email"] = payer_email
		filters["coupon_code"] = coupon_code

		filters = build_query(filters)

		@rest_client.get("/v1/discount_campaigns?" + filters + "&access_token=" + access_token)
    end
end
    

require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'
require 'mercadopagorestclient'

class MerchantOrder < MercadoPagoRestClient
	def initialize(client_id, client_secret, access_token)
		super(client_id, client_secret, access_token)
    end

	def get(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/merchant_orders/" + id + "?access_token=" + access_token)
	end

	def create(merchant_order)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.post("/merchant_orders?access_token=" + access_token, merchant_order)
    end

	def update(id, merchant_order)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.put("/merchant_orders/" + id + "?access_token=" + access_token, merchant_order)
    end
end
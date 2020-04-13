
require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'
require 'mercadopagorestclient'

class Preference < MercadoPagoRestClient
	def initialize(client_id, client_secret, access_token)
		super(client_id, client_secret, access_token)
	end

	def create(preference)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.post("/checkout/preferences?access_token=" + access_token, preference)
    end
    
	def update(id, preference)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.put("/checkout/preferences/" + id + "?access_token=" + access_token, preference)
	end

	def get(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/checkout/preferences/" + id + "?access_token=" + access_token)
	end

end
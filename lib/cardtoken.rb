
require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'
require 'mercadopagorestclient'

class CardToken < MercadoPagoRestClient
	def initialize(client_id, client_secret, access_token)
		super(client_id, client_secret, access_token)
    end

	def get(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/v1/card_tokens/" + id + "?access_token=" + access_token)
	end

	def create(cardtoken)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.post("/v1/card_tokens?access_token=" + access_token, cardtoken)
    end
end
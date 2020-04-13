
require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'
require 'mercadopagorestclient'

class Card < MercadoPagoRestClient
	def initialize(client_id, client_secret, access_token)
		super(client_id, client_secret, access_token)
    end

	def get(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/v1/customers/" + id + "/cards?access_token=" + access_token)
	end

	def create(card)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.post("/v1/customers/" + id + "/cards?access_token=" + access_token, card)
	end

	def update(id, card)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.put("/v1/customers/" + id + "/cards?access_token=" + access_token, card)
	end

	def delete(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.delete("/v1/customers/" + id + "/cards/?access_token=" + access_token)
	end
end

require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'
require 'mercadopagorestclient'

class PreApproval < MercadoPagoRestClient
	def initialize(client_id, client_secret, access_token)
		super(client_id, client_secret, access_token)
    end

    def cancel(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		cancel_status = {"status" => "cancelled"}
		@rest_client.put("/preapproval/" + id + "?access_token=" + access_token, cancel_status)
	end

	def create(preapproval_payment)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.post("/preapproval?access_token=" + access_token, preapproval_payment)
	end

	def get(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/preapproval/" + id + "?access_token=" + access_token)
	end
end
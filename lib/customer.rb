
require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'
require 'mercadopagorestclient'

class Customer < MercadoPagoRestClient
	def initialize(client_id, client_secret, access_token)
		super(client_id, client_secret, access_token)
    end
    
    def search(filters)#, offset=0, limit=0
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

        #tem?
		#filters["offset"] = offset
		#filters["limit"] = limit

		filters = build_query(filters)

		@rest_client.get(uri_prefix + "/v1/customers/search?" + filters + "&access_token=" + access_token)
    end

	def get(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/v1/customers/" + id + "?access_token=" + access_token)
	end

	def create(customer)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.post("/v1/customers?access_token=" + access_token, customer)
    end

	def update(id, customer)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.put("/v1/customers/" + id + "?access_token=" + access_token, customer)
    end

	def delete(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.delete("/v1/customers/" + id + "?access_token=" + access_token)
    end
end
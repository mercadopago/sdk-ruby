
require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'
require 'mercadopago'
require 'mercadopagorestclient'

class Payment < MercadoPagoRestClient
	def initialize(client_id, client_secret, access_token)
		super(client_id, client_secret, access_token)
    end
    
    def get(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		uri_prefix = MercadoPago.sandbox ? "/sandbox" : ""

		@rest_client.get(uri_prefix + "/v1/payments/" + id + "?access_token=" + access_token)
    end
    
    def create(payment)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.post("/v1/payments/?access_token=" + access_token, payment)
	end
    
    def update(id, payment)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.put("/v1/payments/" + id + "?access_token=" + access_token, payment)
	end

	def cancel(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		cancel_status = {"status" => "cancelled"}
		@rest_client.put("/v1/payments/" + id + "?access_token=" + access_token, cancel_status)
    end
    
    def search(filters, offset=0, limit=0)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		filters["offset"] = offset
		filters["limit"] = limit

		filters = build_query(filters)

		uri_prefix = MercadoPago.sandbox ? "/sandbox" : ""

		@rest_client.get(uri_prefix + "/v1/payments/search?" + filters + "&access_token=" + access_token)
    end

    def get_authorized(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/authorized_payments/" + id + "?access_token=" + access_token)
    end
    
    def get_refund(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/v1/payments/" + id + "/refunds?access_token=" + access_token)
	end
    
    def do_refund(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		refund_status = {}
		@rest_client.post("/v1/payments/" + id + "/refunds?access_token=" + access_token, refund_status)
	end
end
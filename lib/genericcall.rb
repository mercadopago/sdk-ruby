
require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'
require 'mercadopagorestclient'

class GenericCall < MercadoPagoRestClient
	def initialize(client_id, client_secret, access_token)
		super(client_id, client_secret, access_token)
    end

    def get(uri, params = nil, authenticate = true)
		if not params.class == Hash
			params = Hash.new
		end

		if authenticate
			begin
				access_token = get_access_token
			rescue => e
				return e.message
			end

			params["access_token"] = access_token
		end

		if not params.empty?
			uri << (if uri.include? "?" then "&" else "?" end) << build_query(params)
		end

		@rest_client.get(uri)
	end

	def post(uri, data, params = nil)
		if not params.class == Hash
			params = Hash.new
		end

		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		params["access_token"] = access_token

		if not params.empty?
			uri << (if uri.include? "?" then "&" else "?" end) << build_query(params)
		end

		@rest_client.post(uri, data)
	end

	def put(uri, data, params = nil)
		if not params.class == Hash
			params = Hash.new
		end

		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		params["access_token"] = access_token

		if not params.empty?
			uri << (if uri.include? "?" then "&" else "?" end) << build_query(params)
		end

		@rest_client.put(uri, data)
	end

	def delete(uri, params = nil)
		if not params.class == Hash
			params = Hash.new
		end

		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		params["access_token"] = access_token

		if not params.empty?
			uri << (if uri.include? "?" then "&" else "?" end) << build_query(params)
		end

		@rest_client.delete(uri)
	end
end
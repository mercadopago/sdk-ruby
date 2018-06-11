#MercadoPago Integration Library
#Access MercadoPago for payments integration
#
#@author @maticompiano
#@contributors @chrismo

require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'

class MercadoPago
	def initialize(*args)
		if args.size < 1 or args.size > 2
			raise "Invalid arguments. Use CLIENT_ID and CLIENT SECRET, or ACCESS_TOKEN"
		end

		@client_id = args.at(0) if args.size == 2
		@client_secret = args.at(1) if args.size == 2
		@ll_access_token = args.at(0) if args.size == 1

		@rest_client = RestClient.new()
		@sandbox = false
	end

	def set_debug_logger(debug_logger)
		@rest_client.set_debug_logger(debug_logger)
	end

	def sandbox_mode(enable=nil)
		if not enable.nil?
			@sandbox = enable
		end

		return @sandbox
	end

	# Get Access Token for API use
	def get_access_token
		if @ll_access_token
			@ll_access_token
		else
			app_client_values = {
				'grant_type' => 'client_credentials',
				'client_id' => @client_id,
				'client_secret' => @client_secret
			}

			@access_data = @rest_client.post("/oauth/token", build_query(app_client_values), RestClient::MIME_FORM)

			if @access_data['status'] == "200"
				@access_data = @access_data["response"]
				@access_data['access_token']
			else
				raise @access_data.inspect
			end
		end
	end

	# Get information for specific payment
	def get_payment(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		uri_prefix = @sandbox ? "/sandbox" : ""
		@rest_client.get("/v1/payments/" + id + "?access_token=" + access_token)
	end

	def get_payment_info(id)
		get_payment(id)
	end

	# Get information for specific authorized payment
	def get_authorized_payment(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/authorized_payments/" + id + "?access_token=" + access_token)
	end

	# Refund accredited payment
	def refund_payment(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		refund_status = {}
		@rest_client.post("/v1/payments/" + id + "/refunds?access_token=" + access_token, refund_status)
	end

	# Cancel pending payment
	def cancel_payment(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		cancel_status = {"status" => "cancelled"}
		@rest_client.put("/v1/payments/" + id + "?access_token=" + access_token, cancel_status)
	end

	# Cancel preapproval payment
	def cancel_preapproval_payment(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		cancel_status = {"status" => "cancelled"}
		@rest_client.put("/preapproval/" + id + "?access_token=" + access_token, cancel_status)
	end

	# Search payments according to filters, with pagination
	def search_payment(filters, offset=0, limit=0)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		filters["offset"] = offset
		filters["limit"] = limit

		filters = build_query(filters)

		uri_prefix = @sandbox ? "/sandbox" : ""
		@rest_client.get("/v1/payments/search?" + filters + "&access_token=" + access_token)
	end

	# Create a checkout preference
	def create_preference(preference)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.post("/checkout/preferences?access_token=" + access_token, preference)
	end

	# Update a checkout preference
	def update_preference(id, preference)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.put("/checkout/preferences/" + id + "?access_token=" + access_token, preference)
	end

	# Get a checkout preference
	def get_preference(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/checkout/preferences/" + id + "?access_token=" + access_token)
	end

	# Create a preapproval payment
	def create_preapproval_payment(preapproval_payment)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.post("/preapproval?access_token=" + access_token, preapproval_payment)
	end

	# Get a preapproval payment
	def get_preapproval_payment(id)
		begin
			access_token = get_access_token
		rescue => e
			return e.message
		end

		@rest_client.get("/preapproval/" + id + "?access_token=" + access_token)
	end

	# Generic resource get
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

	# Generic resource post
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

	# Generic resource put
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

	# Generic resource delete
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

	def build_query(params)
		URI.escape(params.collect { |k, v| "#{k}=#{v}" }.join('&'))
	end

	private

	class RestClient

		MIME_JSON = 'application/json'
		MIME_FORM = 'application/x-www-form-urlencoded'
		API_BASE_URL = URI.parse('https://api.mercadopago.com')

		def initialize(debug_logger=nil)
			@http = Net::HTTP.new(API_BASE_URL.host, API_BASE_URL.port)

			if API_BASE_URL.scheme == "https" # enable SSL/TLS
				@http.use_ssl = true
				@http.verify_mode = OpenSSL::SSL::VERIFY_PEER
				@http.ssl_options = OpenSSL::SSL::OP_NO_SSLv3 # explicitly tell OpenSSL not to use SSL3
				@http.ssl_version = :TLSv1_2
			end

			@http.set_debug_output debug_logger if debug_logger
		end

		def set_debug_logger(debug_logger)
			@http.set_debug_output debug_logger
		end

		def exec(method, uri, data, content_type)
			if not data.nil? and content_type == MIME_JSON
				data = data.to_json
			end

			headers = {
				'User-Agent' => "MercadoPago Ruby SDK v" + MERCADO_PAGO_VERSION,
				'Content-type' => content_type,
				'Accept' => MIME_JSON
			}

			api_result = @http.send_request(method, uri, data, headers)

			{
				"status" => api_result.code,
				"response" => JSON.parse(api_result.body)
			}
		end

		def get(uri, content_type=MIME_JSON)
			exec("GET", uri, nil, content_type)
		end

		def post(uri, data = nil, content_type=MIME_JSON)
			exec("POST", uri, data, content_type)
		end

		def put(uri, data = nil, content_type=MIME_JSON)
			exec("PUT", uri, data, content_type)
		end
		
		def delete(uri, content_type=MIME_JSON)
			exec("DELETE", uri, nil, content_type)
		end
	end
end

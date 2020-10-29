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
		@rest_client.set_access_token(get_access_token)
		@sandbox = false
	end

	def set_debug_logger(debug_logger)
		@rest_client.set_debug_logger(debug_logger)
	end

	def set_platform_id(platform_id)
		@rest_client.set_platform_id(platform_id)
	end

	def set_integrator_id(integrator_id)
		@rest_client.set_integrator_id(integrator_id)
	end

	def set_corporation_id(corporation_id)
		@rest_client.set_corporation_id(corporation_id)
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
		uri_prefix = @sandbox ? "/sandbox" : ""

		@rest_client.get(uri_prefix + "/v1/payments/" + id)

	end

	def get_payment_info(id)
		get_payment(id)
	end

	# Get information for specific authorized payment
	def get_authorized_payment(id)
		@rest_client.get("/authorized_payments/" + id)
	end

	# Refund accredited payment
	def refund_payment(id)
		refund_status = {}
		@rest_client.post("/v1/payments/" + id, refund_status)

	end

	# Cancel pending payment
	def cancel_payment(id)
		cancel_status = {"status" => "cancelled"}
		@rest_client.put("/v1/payments/" + id, cancel_status)
	end

	# Cancel preapproval payment
	def cancel_preapproval_payment(id)
		cancel_status = {"status" => "cancelled"}
		@rest_client.put("/preapproval/" + id, cancel_status)
	end

	# Search payments according to filters, with pagination
	def search_payment(filters, offset=0, limit=0)
		filters["offset"] = offset
		filters["limit"] = limit

		filters = build_query(filters)

		uri_prefix = @sandbox ? "/sandbox" : ""

		@rest_client.get(uri_prefix + "/v1/payments/search?" + filters)

	end

	# Create a checkout preference
	def create_preference(preference)
		@rest_client.post("/checkout/preferences", preference)
	end

	# Update a checkout preference
	def update_preference(id, preference)
		@rest_client.put("/checkout/preferences/" + id, preference)
	end

	# Get a checkout preference
	def get_preference(id)
		@rest_client.get("/checkout/preferences/" + id)
	end

	# Create a preapproval payment
	def create_preapproval_payment(preapproval_payment)
		@rest_client.post("/preapproval", preapproval_payment)
	end

	# Get a preapproval payment
	def get_preapproval_payment(id)
		@rest_client.get("/preapproval/" + id)
	end

	# Generic resource get
	def get(uri, params = nil, authenticate = true)
		if not params.class == Hash
			params = Hash.new
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

				# explicitly tell OpenSSL not to use SSL3 nor TLS 1.0
				@http.ssl_options = OpenSSL::SSL::OP_NO_SSLv3 + OpenSSL::SSL::OP_NO_TLSv1
			end

			@http.set_debug_output debug_logger if debug_logger

			@platform_id = nil
			@integrator_id = nil
			@corporation_id = nil
			@access_token = nil
		end

		def set_debug_logger(debug_logger)
			@http.set_debug_output debug_logger
		end

		def set_platform_id(platform_id)
			@platform_id = platform_id
		end

		def set_integrator_id(integrator_id)
			@integrator_id = integrator_id
		end

		def set_corporation_id(corporation_id)
			@corporation_id = corporation_id
		end

		def set_access_token(access_token)
			@access_token = access_token
		end

		def exec(method, uri, data, content_type)
			if not data.nil? and content_type == MIME_JSON
				data = data.to_json
			end

			headers = {
				'x-product-id' => PRODUCT_ID,
				'x-tracking-id' => "platform:"+RUBY_VERSION.split('.')[0]+"|"+RUBY_VERSION+",type:SDK"+MERCADO_PAGO_VERSION+",so;",
				'User-Agent' => "MercadoPago Ruby SDK v" + MERCADO_PAGO_VERSION,
				'Content-type' => content_type,
				'Accept' => MIME_JSON
			}

			headers['Authorization'] = "Bearer " + @access_token if @access_token != nil
			headers['x-platform-id'] = @platform_id if @platform_id != nil
			headers['x-integrator-id'] = @integrator_id if @integrator_id != nil
			headers['x-corporation-id'] = @corporation_id if @corporation_id != nil

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

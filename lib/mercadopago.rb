#MercadoPago Integration Library
#Access MercadoPago for payments integration
#
#@author @maticompiano

class MercadoPago
	require 'rubygems'
	require 'json/add/core'
	require 'uri'
	require 'net/https'

	def self.version 
		"0.1.8"
	end

	def initialize(client_id, client_secret)
		@client_id = client_id
		@client_secret = client_secret
		@restClient = RestClient.new()
		@access_data
		@sandbox = false
	end

	def sandbox_mode(enable=nil)
		if not enable.nil?
			@sandbox = enable
		end

		return @sandbox
	end

	# Get Access Token for API use
	def get_access_token()
		appClientValues = {
			'grant_type'	=> 'client_credentials',
			'client_id'		=> @client_id,
			'client_secret'	=> @client_secret
		}
		
		@access_data = @restClient.post("/oauth/token", build_query(appClientValues) , @restClient.MIME_FORM)
		
        if @access_data['status'] == "200"
			@access_data = @access_data["response"]
			return @access_data['access_token']
        else
			raise @access_data.inspect
        end
	end
	
	# Get information for specific payment
    def get_payment_info(id)
        
        begin
			accessToken = get_access_token()
		rescue => e
			return e.message
		end

		uriPrefix = @sandbox ? "/sandbox" : ""
		
		paymentInfo = @restClient.get(uriPrefix + "/collections/notifications/" + id + "?access_token=" + accessToken)

		return paymentInfo

	end
	
	# Refund accredited payment
    def refund_payment(id)
        
        begin
			accessToken = get_access_token()
		rescue => e
			return e.message
		end
		
		refund_status = {"status"=> "refunded"}
		response = @restClient.put("/collections/" + id + "?access_token=" + accessToken, refund_status)
			
		return response
		
	end
	
	# Cancel pending payment
    def cancel_payment(id)
        
		begin
			accessToken = get_access_token()
		rescue => e
			return e.message
		end
		
		cancel_status = {"status"=> "cancelled"}
		response = @restClient.put("/collections/" + id + "?access_token=" + accessToken, cancel_status)
		
		return response

	end
	
	# Search payments according to filters, with pagination
    def search_payment(filters, offset=0, limit=0)
		
		begin
			accessToken = get_access_token()
		rescue => e
			return e.message
		end

		filters["offset"] = offset
		filters["limit"] = limit

		filters = build_query(filters)

		uriPrefix = @sandbox ? "/sandbox" : ""
		
		paymentResult = @restClient.get(uriPrefix + "/collections/search?" + filters + "&access_token=" + accessToken)
		
		return paymentResult

	end
	
	# Create a checkout preference
    def create_preference (preference)
    
		begin
			accessToken = get_access_token()
		rescue => e
			return e.message
		end
		
		preferenceResult = @restClient.post("/checkout/preferences?access_token=" + accessToken, preference)
		
		return preferenceResult
	end
	
	# Update a checkout preference
    def update_preference (id,preference)
    
		begin
			accessToken = get_access_token()
		rescue => e
			return e.message
		end
			
        preferenceResult = @restClient.put("/checkout/preferences/" + id + "?access_token=" + accessToken, preference)

		return preferenceResult
	
	end
	
	# Get a checkout preference
    def get_preference (id)
    
		begin
			accessToken = get_access_token()
		rescue => e
			return e.message
		end
			
        preferenceResult = @restClient.get("/checkout/preferences/" + id + "?access_token=" + accessToken)
		
		return preferenceResult
	
	end
	
	def build_query(params)

		URI.escape(params.collect{|k,v| "#{k}=#{v}"}.join('&'))

	end

	####################
		
	private

		class RestClient
		
			attr_accessor :MIME_JSON, :MIME_FORM
			
			def initialize()
				@MIME_JSON = "application/json"
				@MIME_FORM = "application/x-www-form-urlencoded"
				@API_BASE_URL = URI.parse("https://api.mercadolibre.com")
				
				@http = Net::HTTP.new(@API_BASE_URL.host, @API_BASE_URL.port)
				
				if @API_BASE_URL.scheme == "https"  # enable SSL/TLS
					@http.use_ssl = true
					@http.verify_mode = OpenSSL::SSL::VERIFY_PEER
					@http.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
				end
				
			end

			def exec(method, uri, data, contentType)
	 
				if not data.nil? and contentType == @MIME_JSON
					data = data.to_json
				end
				
				headers = {
					'User-Agent' => "MercadoPago Ruby SDK v"+MercadoPago.version,
					'Content-type' => contentType, 
					'Accept' => @MIME_JSON
				}

				apiResult = @http.send_request(method, uri, data, headers)

				response = {
					"status"=> apiResult.code,
					"response"=> JSON.parse(apiResult.body)
				}

				return response
			
			end

			def get(uri, contentType=@MIME_JSON)

				return exec("GET", uri, nil, contentType)
			
			end

			def post(uri, data = nil, contentType=@MIME_JSON)

				return exec("POST", uri, data, contentType)
			
			end
		
			def put(uri, data = nil, contentType=@MIME_JSON)
			
				return exec("PUT", uri, data, contentType)
			
			end

	end

end

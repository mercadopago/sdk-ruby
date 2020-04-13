require 'restclient'

class MercadoPagoRestClient
    def initialize(client_id, client_secret, access_token)
		@client_id = client_id
		@client_secret = client_secret
		@ll_access_token = access_token
        @rest_client = RestClient.new()
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

    def build_query(params)
		URI.escape(params.collect { |k, v| "#{k}=#{v}" }.join('&'))
    end
end
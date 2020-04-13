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
    end

    def set_debug_logger(debug_logger)
        @http.set_debug_output debug_logger
    end

    def exec(method, uri, data, content_type)
        if not data.nil? and content_type == MIME_JSON
            data = data.to_json
        end

        headers = {
            'x-product-id' => PRODUCT_ID,
            'x-tracking-id' => "platform:"+RUBY_VERSION+",type:SDK"+MERCADO_PAGO_VERSION+",so;",
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
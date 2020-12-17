module Mercadopago
    class RequestOptions

        attr_reader :access_token, :connection_timeout, :custom_headers, :corporation_id, :integrator_id, :platform_id, :max_retries
        
        def initialize(access_token: nil, 
                     connection_timeout: 60.0, 
                     custom_headers: nil, 
                     corporation_id: nil, 
                     integrator_id: nil, 
                     platform_id: nil, 
                     max_retries: 3)
            self.access_token = access_token unless access_token.nil?
            self.connection_timeout = connection_timeout
            self.custom_headers = custom_headers unless custom_headers.nil?
            self.corporation_id = corporation_id unless corporation_id.nil?
            self.integrator_id = integrator_id unless integrator_id.nil?
            self.platform_id = platform_id unless platform_id.nil?
            self.max_retries = max_retries

            @config = Config.new
        end

        def get_headers()
            headers = {'Authorization': 'Bearer ' + @access_token,
                'x-product-id': @config.product_id, 
                'x-tracking-id': @config.tracking_id,
                'User-Agent': @config.user_agent,
                'Accept': @config.mime_json,
                'Content-Type': @config.mime_json}


            headers['x-corporation-id'] = @corporation_id unless @corporation_id.nil?
            headers['x-integrator-id'] = @integrator_id unless @integrator_id.nil?
            headers['x-platform-id'] = @platform_id unless @platform_id.nil?
        
            headers.merge(@custom_headers) unless @custom_headers.nil?

            headers
        end

        def access_token=(value)
            raise TypeError, 'Param access_token must be a String' unless value.kind_of?(String)
            @access_token = value
        end

        def custom_headers=(value)
            raise TypeError, 'Param custom_headers must be a Hash' unless value.kind_of?(Hash)
            @custom_headers = value
        end

        def connection_timeout=(value)
            raise TypeError, 'Param connection_timeout must be a Float' unless value.kind_of?(Float)
            @connection_timeout = value
        end

        def corporation_id=(value)
            raise TypeError, 'Param corporation_id must be a String' unless value.kind_of?(String)
            @corporation_id = value
        end

        def integrator_id=(value)
            raise TypeError, 'Param integrator_id must be a String' unless value.kind_of?(String)
            @integrator_id = value
        end

        def platform_id=(value)
            raise TypeError, 'Param platform_id must be a String' unless value.kind_of?(String)
            @platform_id = value
        end

        def max_retries=(value)
            raise TypeError, 'Param max_retries must be a Integer' unless value.kind_of?(Integer)
            @max_retries = value
        end

    end
end
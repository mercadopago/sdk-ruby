module Mercadopago
    class MPBase
        def initialize(request_options, http_client)
            raise TypeError, 'Param request_options must be a RequestOptions object' unless request_options.is_a?(RequestOptions)

            @request_options = request_options
            @http_client = http_client
            @config = Config.new
        end
    
        def _check_request_options(request_options=nil)
            request_options = @request_options if request_options.nil?
            raise TypeError, 'Param request_options must be a RequestOptions object' unless request_options.is_a?(RequestOptions)

            request_options.access_token = @request_options.access_token if request_options.access_token.nil?

            request_options
        end

        def _get(uri:, filters:nil, request_options:nil)
            raise TypeError, 'Filters must be a ' unless filters.nil? or filters.is_a?(Hash)
            request_options = _check_request_options(request_options)
            @http_client.get(url=@config.api_base_url + uri, headers=request_options.get_headers(), filters=filters, timeout=request_options.connection_timeout)
        end

        def _post(uri:, data:, filters:nil, request_options:nil)
            raise TypeError, 'Filters must be a ' unless filters.nil? or filters.is_a?(Hash) 
            request_options = _check_request_options(request_options)
            @http_client.post(url=@config.api_base_url + uri, data.to_json, headers=request_options.get_headers(),  filters=filters, timeout=request_options.connection_timeout)
        end

        def _put(uri:, data:, filters:nil, request_options:nil)
            raise TypeError, 'Filters must be a ' unless filters.nil? or filters.is_a?(Hash) 
            request_options = _check_request_options(request_options)
            @http_client.put(url=@config.api_base_url + uri, data.to_json, headers=request_options.get_headers(),  filters=filters, timeout=request_options.connection_timeout)
        end
    end
end




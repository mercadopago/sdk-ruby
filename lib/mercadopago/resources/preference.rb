module Mercadopago
    class Preference < MPBase
        def initialize(request_options, http_client)
            super(request_options, http_client)
        end

        def get(preference_id=nil, request_options:nil)
            _get(uri:"/checkout/preferences/#{preference_id}", request_options: request_options)
        end

        def post(data, request_options:nil)
            _post(uri:"/checkout/preferences", data:data, request_options:request_options)
        end

        def put(preference_id, data, request_options:nil)
            puts data
            _put(uri:"/checkout/preferences/#{preference_id}", data:data, request_options:request_options)
        end

    end
end
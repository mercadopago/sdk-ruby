module Mercadopago
    class Preference < MPBase
        def initialize(request_options, http_client)
            super(request_options, http_client)
        end

        def get(request_options:nil)
            _get(uri:"/checkout/preferences", request_options:request_options)
        end

        def post(data, request_options:nil)
            _post(uri:"/checkout/preferences", data:data, request_options:request_options)
        end

        def put(data, request_options:nil)
            _put(uri:"/checkout/preferences", data:data, request_options:request_options)
        end

    end
end
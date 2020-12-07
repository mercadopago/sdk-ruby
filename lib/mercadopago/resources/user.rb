module Mercadopago
    class User < MPBase
        def initialize(request_options, http_client)
            super(request_options, http_client)
        end

        def get(request_options=nil)
            _get(uri="/users/me", request_options=request_options)
        end
    end
end
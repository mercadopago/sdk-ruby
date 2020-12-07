module Mercadopago
    class IdentificationType < MPBase
        def initialize(request_options, http_client)
            super(request_options, http_client)
        end

        def get(request_options:nil)
            _get(uri: "/v1/identification_types", request_options: request_options)
        end
    end
end
module Mercadopago
    class Card < MPBase
        def initialize(request_options, http_client)
            super(request_options, http_client)
        end

        def get(customer_id:, card_id:, request_options:nil)
            _get(uri: "/v1/customers/#{customer_id}/cards/#{card_id}", request_options: request_options)
        end
    end
end
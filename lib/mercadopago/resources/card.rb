module Mercadopago
    class Card < MPBase
        def initialize(request_options, http_client)
            super(request_options, http_client)
        end

        def get(customer_id:, card_id:, request_options:nil)
            _get(uri: "/v1/customers/#{customer_id}/cards/#{card_id}", request_options: request_options)
        end

        def create(customer_id:, card_object:, request_options:nil)
            raise TypeError, 'Param card_object must be a Hash' if card_object.nil? or !card_object.is_a?(Hash)
            _post(uri: "/v1/customers/#{customer_id}/cards/", data:card_object, request_options: request_options)
        end
    end
end
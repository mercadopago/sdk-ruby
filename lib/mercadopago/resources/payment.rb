module Mercadopago

    ###
    #This class provides the methods to access the API that will allow you to create your own payment experience on your website.
    
    #From basic to advanced configurations, you control the whole experience.
    
    #[Click here for more infos](https://www.mercadopago.com.br/developers/en/guides/online-payments/checkout-api/introduction/)
    
    class Payment < MPBase
        def initialize(request_options, http_client)
            super(request_options, http_client)
        end

        def search(filters=nil, request_options:nil)
            raise TypeError, 'Param filters must be a Hash' unless filters.is_a?(Hash)
            _get(uri:"/v1/payments/search", filters: filters, request_options: request_options)
        end

        def get(payment_id, request_options:nil)
            _get(uri:"/v1/payments/#{payment_id}", request_options: request_options)
        end

        def create(payment_object, request_options:nil)
            raise TypeError, 'Param payment_object must be a Hash' unless payment_object.is_a?(Hash)
            _post(uri:"/v1/payments/", data:payment_object, request_options:request_options)
        end

        def update(payment_id, payment_object, request_options:nil)
            raise TypeError, 'Param payment_object must be a Hash' unless payment_object.is_a?(Hash)
            _put(uri:"/v1/payments/#{preference_id}", data:payment_object, request_options:request_options)
        end

    end
end
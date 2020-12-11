module Mercadopago
    class Customer < MPBase
        def initialize(request_options, http_client)
            super(request_options, http_client)
        end

        def search(filters=nil, request_options:nil)
            _get(uri:"/v1/customers/search", filters: filters, request_options: request_options)
        end

        def get(customer_id=nil, request_options:nil)
            _get(uri:"/v1/customers/#{customer_id}", request_options: request_options)
        end

        def create(customer_object, request_options:nil)
            raise TypeError, 'Param customer_object must be a Hash' unless customer_object.is_a?(Hash)
            _post(uri:"/v1/customers", data:customer_object, request_options:request_options)
        end

        def update(customer_id, customer_object, request_options:nil)
            raise TypeError, 'Param customer_object must be a Hash' unless customer_object.is_a?(Hash)
            _put(uri:"/v1/customers/#{customer_id}", data:customer_object, request_options:request_options)
        end

        def delete(customer_id, request_options:nil)
            _delete(uri:"/v1/customers/#{customer_id}", request_options:request_options)
        end

    end
end
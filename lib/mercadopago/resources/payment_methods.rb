module Mercadopago

    ###
    #Access to Payment Methods
  
    class PaymentMethods < MPBase
        def initialize(request_options, http_client)
            super(request_options, http_client)
        end

        def get(request_options:nil)
            _get(uri:"/v1/payment_methods", request_options: request_options)
        end

    end
end
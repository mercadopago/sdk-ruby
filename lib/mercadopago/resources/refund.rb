module Mercadopago
    ###
    #This class will allow you to refund payments created through the Payments class.
    #You can refund a payment within 180 days after it was approved.
    
    #You must have sufficient funds in your account in order to successfully refund the payment amount. Otherwise, you will get a 400 Bad Request error.
    
    #[Click here for more infos](https://www.mercadopago.com.br/developers/en/guides/manage-account/account/cancellations-and-refunds#bookmark_refunds)
    

    class Refund < MPBase

        def initialize(request_options, http_client)
            super(request_options, http_client)
        end
     
        def search(payment_id, request_options:nil)
            _get(uri:"/v1/payments/#{payment_id}/refunds", request_options: request_options)
        end

        def create(payment_id, payment_object=nil, request_options:nil)
            _post(uri:"/v1/payments/#{payment_id}/refunds", data:payment_object, request_options:request_options)
        end

    end
end
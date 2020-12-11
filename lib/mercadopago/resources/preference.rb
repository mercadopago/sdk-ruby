module Mercadopago
    class Preference < MPBase
        def initialize(request_options, http_client)
            super(request_options, http_client)
        end

        def get(preference_id, request_options:nil)
            _get(uri:"/checkout/preferences/#{preference_id}", request_options: request_options)
        end

        def create(preference_object, request_options:nil)
            raise TypeError, 'Param preference_object must be a Hash' unless preference_object.is_a?(Hash)
            _post(uri:"/checkout/preferences", data:preference_object, request_options:request_options)
        end

        def update(preference_id, preference_object, request_options:nil)
            raise TypeError, 'Param preference_object must be a Hash' unless preference_object.is_a?(Hash)
            _put(uri:"/checkout/preferences/#{preference_id}", data:preference_object, request_options:request_options)
        end

    end
end
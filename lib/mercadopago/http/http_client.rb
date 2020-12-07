require 'rest-client'
require 'json'

module Mercadopago
    class HttpClient
        def get(url, headers, filters=nil, timeout=nil, maxretries=nil)
            result = RestClient::Request.execute(method: :get,  url: url, params: filters, headers: headers, timeout: timeout)
            response = {
                status: result.code,
                body: JSON.parse(result.body)
            }
        end

    # def post(url, headers, data=nil, params=nil):

    #     result = RestClient.post(url, params=params, data=data, headers=headers)

    #     response = {
    #         status: result.code,
    #         body: JSON.parse(result.body)
    #     }

    #     return response
    # end

    # def put(url, headers, data=nil, params=nil):

    #     result = RestClient.put(url, params=params, data=data, headers=headers)

    #     response = {
    #         status: result.code,
    #         body: JSON.parse(result.body)
    #     }

    #     return response
    # end

    # def delete(url, headers, params=nil):

    #     result = RestClient.delete(url, params=params, headers=headers)

    #     response = {
    #         status: result.code,
    #         body: JSON.parse(result.body)
    #     }

    #     return response
    # end
    end
end

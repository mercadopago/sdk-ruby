require_relative '../sdk'
require 'rest-client'
require 'json'

include SDK  

module HttpClient  

    def get(uri, params)
        result = RestClient::Request.execute(method: :get,  url: uri, headers: {params: {access_token: SDK::token, params: params} })
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


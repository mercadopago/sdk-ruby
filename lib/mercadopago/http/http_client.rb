require 'rest-client'
require 'json'

module Mercadopago
    class HttpClient
        def get(url, headers, filters=nil, timeout=nil, maxretries=nil)
            try = 0
            begin
                result = RestClient::Request.execute(method: :get,  url: url, params: filters, headers: headers, timeout: timeout)
                response = {
                    status: result.code,
                    response: JSON.parse(result.body)
                }
            rescue RestClient::Exception => err
                try += 1
                retry if [429, 500, 502, 503, 504].include? err.http_code and try < maxretries
                response = {
                    status: err.http_code,
                    response: JSON.parse(err.response.body)
                }
            end
        end

        def post(url, data, headers, params=nil, timeout=nil, maxretries=nil)
            begin
                result = RestClient::Request.execute(method: :post,  url: url, payload: data, headers: headers, params: params, timeout: timeout)
                response = {
                    status: result.code,
                    response: JSON.parse(result.body)
                }
            rescue RestClient::Exception => err
                response = {
                    status: err.http_code,
                    response: JSON.parse(err.response.body)
                }
            end
        end

        def put(url, data, headers, params=nil, timeout=nil, maxretries=nil)
            begin
                result = RestClient::Request.execute(method: :put,  url: url, payload: data, headers: headers, params: params, timeout: timeout)
                response = {
                    status: result.code,
                    response: JSON.parse(result.body)
                }
            rescue RestClient::Exception => err
                response = {
                    status: err.http_code,
                    response: JSON.parse(err.response.body)
                }
            end
        end

        def delete(url, headers, params=nil, timeout=nil, maxretries=nil)
            begin
                result = RestClient::Request.execute(method: 'delete',  url: url, headers: headers, headers: params, timeout: timeout)
                response = {
                    status: result.code,
                    response: JSON.parse(result.body)
                }
            rescue RestClient::Exception => err
                response = {
                    status: err.http_code,
                    response: JSON.parse(err.response.body)
                }
            end
        end
    end
end

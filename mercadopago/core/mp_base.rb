require_relative '../config/config'
require_relative '../http/http_client'

include Config
include HttpClient

module MpBase
    
    def get_(uri, param)
        HttpClient::get(API_BASE_URL + uri, param)
    end

end




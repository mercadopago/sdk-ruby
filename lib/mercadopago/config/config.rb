# typed: true
# frozen_string_literal: true

module Mercadopago
  class Config
    @@VERSION = '2.1.0'
    @@USER_AGENT = "MercadoPago Ruby SDK v#{@@VERSION}"
    @@PRODUCT_ID = 'bc32a7vtrpp001u8nhjg'
    @@TRACKING_ID =  "plataform: ?,type:SDK#{@@VERSION},so;"
    @@API_BASE_URL = 'https://api.mercadopago.com'
    @@MIME_JSON = 'application/json'
    @@MIME_FORM = 'application/x-www-form-urlencoded'

    def version
      @@VERSION
    end

    def user_agent
      @@USER_AGENT
    end

    def product_id
      @@PRODUCT_ID
    end

    def tracking_id
      @@TRACKING_ID
    end

    def api_base_url
      @@API_BASE_URL
    end

    def mime_json
      @@MIME_JSON
    end

    def mime_form
      @@MIME_FORM
    end
  end
end

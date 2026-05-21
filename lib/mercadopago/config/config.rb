# typed: true
# frozen_string_literal: true

module Mercadopago
  # Holds SDK-wide configuration constants: version, API base URL,
  # User-Agent header, tracking identifiers, and MIME types.
  #
  # Instances are created internally by {MPBase} and {RequestOptions};
  # there is no need to instantiate this class directly.
  class Config
    # Current SDK version following SemVer.
    @@VERSION = '2.4.1'

    # User-Agent string sent with every HTTP request for server-side tracking.
    @@USER_AGENT = "MercadoPago Ruby SDK v#{@@VERSION}"

    # Internal product identifier registered with the MercadoPago platform.
    @@PRODUCT_ID = 'bc32a7vtrpp001u8nhjg'

    # Tracking string that reports Ruby version and SDK version to the API.
    @@TRACKING_ID =  "platform:#{RUBY_VERSION},type:SDK#{@@VERSION},so;"

    # Base URL for all MercadoPago REST API endpoints.
    @@API_BASE_URL = 'https://api.mercadopago.com'

    # MIME type used for JSON request/response bodies.
    @@MIME_JSON = 'application/json'

    # MIME type used for form-encoded request bodies.
    @@MIME_FORM = 'application/x-www-form-urlencoded'

    # @return [String] current SDK version (e.g. "2.4.1")
    def version
      @@VERSION
    end

    # @return [String] User-Agent header value
    def user_agent
      @@USER_AGENT
    end

    # @return [String] MercadoPago internal product identifier
    def product_id
      @@PRODUCT_ID
    end

    # @return [String] tracking string with Ruby and SDK versions
    def tracking_id
      @@TRACKING_ID
    end

    # @return [String] MercadoPago API base URL
    def api_base_url
      @@API_BASE_URL
    end

    # @return [String] JSON MIME type
    def mime_json
      @@MIME_JSON
    end

    # @return [String] form-encoded MIME type
    def mime_form
      @@MIME_FORM
    end
  end
end

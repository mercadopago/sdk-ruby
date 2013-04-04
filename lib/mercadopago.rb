#MercadoPago Integration Library
#Access MercadoPago for payments integration
#
#@author @maticompiano

require 'rubygems'
require 'json/add/core'
require 'uri'
require 'net/https'
require 'yaml'
require 'version'

class MercadoPago
  def self.load_from_config(config_fn=self.default_config_fn)
    conf = YAML.load_file(config_fn)
    new(conf['client_id'], conf['client_secret'])
  end

  def self.default_config_fn
    File.join(File.dirname(__FILE__), '..', 'config', 'mercadopago.yml')
  end

  attr_accessor :sandbox

  def initialize(client_id, client_secret, debug_logger=nil)
    @client_id = client_id
    @client_secret = client_secret
    @rest_client = RestClient.new(debug_logger)
    @sandbox = false
  end

  def set_debug_logger(debug_logger)
    @rest_client.set_debug_logger(debug_logger)
  end

  # Get Access Token for API use
  def get_access_token
    app_client_values = {
        'grant_type' => 'client_credentials',
        'client_id' => @client_id,
        'client_secret' => @client_secret
    }

    @access_data = @rest_client.post("/oauth/token", build_query(app_client_values), RestClient::MIME_FORM)

    if @access_data['status'] == "200"
      @access_data = @access_data["response"]
      @access_data['access_token']
    else
      raise @access_data.inspect
    end
  end

  # Get information for specific payment
  def get_payment_info(id)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    uri_prefix = @sandbox ? "/sandbox" : ""
    @rest_client.get(uri_prefix + "/collections/notifications/" + id + "?access_token=" + access_token)
  end

  # Refund accredited payment
  def refund_payment(id)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    refund_status = {"status" => "refunded"}
    @rest_client.put("/collections/" + id + "?access_token=" + access_token, refund_status)
  end

  # Cancel pending payment
  def cancel_payment(id)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    cancel_status = {"status" => "cancelled"}
    @rest_client.put("/collections/" + id + "?access_token=" + access_token, cancel_status)
  end

  # Search payments according to filters, with pagination
  def search_payment(filters, offset=0, limit=0)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    filters["offset"] = offset
    filters["limit"] = limit

    filters = build_query(filters)

    uri_prefix = @sandbox ? "/sandbox" : ""
    @rest_client.get(uri_prefix + "/collections/search?" + filters + "&access_token=" + access_token)
  end

  # Create a checkout preference
  def create_preference(preference)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    @rest_client.post("/checkout/preferences?access_token=" + access_token, preference)
  end

  # Update a checkout preference
  def update_preference(id, preference)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    @rest_client.put("/checkout/preferences/" + id + "?access_token=" + access_token, preference)
  end

  # Get a checkout preference
  def get_preference(id)
    begin
      access_token = get_access_token
    rescue => e
      return e.message
    end

    @rest_client.get("/checkout/preferences/" + id + "?access_token=" + access_token)
  end

  def build_query(params)
    URI.escape(params.collect { |k, v| "#{k}=#{v}" }.join('&'))
  end

  private

  class RestClient

    MIME_JSON = 'application/json'
    MIME_FORM = 'application/x-www-form-urlencoded'
    API_BASE_URL = URI.parse('https://api.mercadolibre.com')

    def initialize(debug_logger=nil)
      @http = Net::HTTP.new(API_BASE_URL.host, API_BASE_URL.port)

      if API_BASE_URL.scheme == "https" # enable SSL/TLS
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        @http.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
      end

      @http.set_debug_output debug_logger if debug_logger
    end

    def set_debug_logger(debug_logger)
      @http.set_debug_output debug_logger
    end

    def exec(method, uri, data, content_type)
      if content_type == MIME_JSON
        data = data.to_json
      end

      headers = {
          'User-Agent' => "MercadoPago Ruby SDK v" + MERCADO_PAGO_VERSION,
          'Content-type' => content_type,
          'Accept' => MIME_JSON
      }

      api_result = @http.send_request(method, uri, data, headers)

      {
          "status" => api_result.code,
          "response" => JSON.parse(api_result.body)
      }
    end

    def get(uri, content_type=MIME_JSON)
      exec("GET", uri, "", content_type)
    end

    def post(uri, data = "", content_type=MIME_JSON)
      exec("POST", uri, data, content_type)
    end

    def put(uri, data = "", content_type=MIME_JSON)
      exec("PUT", uri, data, content_type)
    end
  end
end

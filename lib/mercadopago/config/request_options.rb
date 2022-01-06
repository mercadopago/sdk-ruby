# typed: true
# frozen_string_literal: true

module Mercadopago
  class RequestOptions
    attr_reader :access_token, :connection_timeout, :custom_headers, :corporation_id, :integrator_id,
                :platform_id, :max_retries

    def initialize(access_token: nil,
                   connection_timeout: 60.0,
                   custom_headers: nil,
                   corporation_id: nil,
                   integrator_id: nil,
                   platform_id: nil,
                   max_retries: 3)
      self.access_token = access_token
      self.connection_timeout = connection_timeout
      self.custom_headers = custom_headers
      self.corporation_id = corporation_id
      self.integrator_id = integrator_id
      self.platform_id = platform_id
      self.max_retries = max_retries

      @config = Config.new
    end

    def get_headers
      headers = { 'Authorization': "Bearer #{@access_token}",
                  'x-product-id' => @config.product_id,
                  'x-tracking-id' => @config.tracking_id,
                  'x-idempotency-key' => SecureRandom.uuid,
                  'User-Agent' => @config.user_agent,
                  'Accept': @config.mime_json }

      headers['x-corporation-id'] = @corporation_id unless @corporation_id.nil?
      headers['x-integrator-id'] = @integrator_id unless @integrator_id.nil?
      headers['x-platform-id'] = @platform_id unless @platform_id.nil?

      headers.merge!(@custom_headers) unless @custom_headers.nil?

      headers
    end

    def access_token=(value)
      raise TypeError, 'Param access_token must be a String' unless access_token.nil? || value.is_a?(String)

      @access_token = value
    end

    def custom_headers=(value)
      raise TypeError, 'Param custom_headers must be a Hash' unless value.nil? || value.is_a?(Hash)

      @custom_headers = value
    end

    def connection_timeout=(value)
      raise TypeError, 'Param connection_timeout must be a Float' unless value.is_a?(Float)

      @connection_timeout = value
    end

    def corporation_id=(value)
      raise TypeError, 'Param corporation_id must be a String' unless value.nil? || value.is_a?(String)

      @corporation_id = value
    end

    def integrator_id=(value)
      raise TypeError, 'Param integrator_id must be a String' unless value.nil? || value.is_a?(String)

      @integrator_id = value
    end

    def platform_id=(value)
      raise TypeError, 'Param platform_id must be a String' unless value.nil? || value.is_a?(String)

      @platform_id = value
    end

    def max_retries=(value)
      raise TypeError, 'Param max_retries must be a Integer' unless value.is_a?(Integer)

      @max_retries = value
    end
  end
end

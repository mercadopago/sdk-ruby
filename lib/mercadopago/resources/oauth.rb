# typed: true
# frozen_string_literal: true

require 'uri'

module Mercadopago
  # Manages the OAuth 2.0 authorization code flow.
  #
  # Use this resource when your application needs to operate on behalf
  # of other MercadoPago sellers (marketplace or platform scenarios).
  # The flow involves redirecting the seller to the authorization URL,
  # receiving an authorization code, and exchanging it for access and
  # refresh tokens.
  #
  # @see https://www.mercadopago.com/developers/en/docs/security/oauth/creation
  class OAuth < MPBase
    AUTH_URL = 'https://auth.mercadopago.com/authorization'
    private_constant :AUTH_URL

    # Builds the MercadoPago authorization URL for the OAuth flow.
    #
    # Redirect the seller to this URL to start the authorization process.
    # After granting permission, MercadoPago redirects back to +redirect_uri+
    # with a +code+ query parameter.
    #
    # @param app_id [String] your MercadoPago application's client ID
    # @param redirect_uri [String] URI where MercadoPago sends the seller after authorization
    # @param random_id [String] CSRF-protection state parameter; must be unique per request
    # @return [String] full authorization URL with query parameters
    # @see https://www.mercadopago.com/developers/en/docs/security/oauth/creation
    def get_authorization_url(app_id, redirect_uri, random_id)
      params = URI.encode_www_form(
        client_id: app_id,
        response_type: 'code',
        platform_id: 'mp',
        state: random_id,
        redirect_uri: redirect_uri
      )
      "#{AUTH_URL}?#{params}"
    end

    # Exchanges an authorization code for an access token.
    #
    # Call this after receiving the +code+ parameter in your +redirect_uri+
    # callback. The returned access token can be used to make API requests
    # on behalf of the authorizing seller.
    #
    # @param oauth_data [Hash] authorization request fields:
    #   +:client_secret+ (your access token), +:code+ (authorization code),
    #   +:redirect_uri+ (must match the one used in {#get_authorization_url}),
    #   and +:grant_type+ (++"authorization_code"++).
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with +access_token+,
    #   +refresh_token+, and +expires_in+
    # @raise [TypeError] if +oauth_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/authentication/oauth/_oauth_token/post
    def create(oauth_data, request_options: nil)
      raise TypeError, 'Param oauth_data must be a Hash' unless oauth_data.is_a?(Hash)

      _post(uri: '/oauth/token', data: oauth_data, request_options: request_options)
    end

    # Refreshes an expired access token.
    #
    # Use this to extend the seller's session without requiring them to
    # re-authorize. The +refresh_token+ is obtained from the initial
    # {#create} response.
    #
    # @param oauth_data [Hash] refresh request fields:
    #   +:client_secret+ (your access token), +:refresh_token+ (token to refresh),
    #   and +:grant_type+ (++"refresh_token"++).
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with a fresh
    #   +access_token+ and +refresh_token+
    # @raise [TypeError] if +oauth_data+ is not a Hash
    # @see https://www.mercadopago.com/developers/en/reference/authentication/oauth/_oauth_token/post
    def refresh(oauth_data, request_options: nil)
      raise TypeError, 'Param oauth_data must be a Hash' unless oauth_data.is_a?(Hash)

      _post(uri: '/oauth/token', data: oauth_data, request_options: request_options)
    end
  end
end

# typed: true
# frozen_string_literal: true

module Mercadopago
  # Main entry point and factory for the MercadoPago Ruby SDK.
  #
  # Holds the OAuth access token, the HTTP transport, and the request
  # configuration. Every API resource is exposed as a method that returns
  # a ready-to-use resource instance (e.g. +sdk.payment+, +sdk.customer+).
  #
  # @example Minimal setup
  #   sdk = Mercadopago::SDK.new('APP_ACCESS_TOKEN')
  #   result = sdk.payment.create(transaction_amount: 100, ...)
  #
  # @example With custom options
  #   opts = Mercadopago::RequestOptions.new(
  #     access_token: 'APP_ACCESS_TOKEN',
  #     connection_timeout: 120.0,
  #     integrator_id: 'INTEGRATOR_ID'
  #   )
  #   sdk = Mercadopago::SDK.new('APP_ACCESS_TOKEN', request_options: opts)
  class SDK
    # @!attribute [r] access_token
    #   @return [String] OAuth access token used for API authentication
    # @!attribute [r] http_client
    #   @return [HttpClient] HTTP transport layer
    attr_reader :access_token, :http_client

    # Creates a new SDK instance.
    #
    # @param access_token [String] OAuth access token (required)
    # @param http_client [HttpClient, nil] custom HTTP transport; defaults to a new {HttpClient}
    # @param request_options [RequestOptions, nil] custom request config; defaults to a new {RequestOptions}
    # @raise [TypeError] if any parameter is not the expected type
    def initialize(access_token, http_client: nil, request_options: nil)
      self.access_token = access_token
      self.http_client = http_client.nil? ? HttpClient.new : http_client
      self.request_options = request_options.nil? ? RequestOptions.new(access_token: access_token) : request_options
    end

    # @return [AdvancedPayment] resource for split-payment operations (marketplace)
    def advanced_payment
      AdvancedPayment.new(request_options, http_client)
    end

    # @return [Card] resource for managing stored cards linked to a customer
    def card
      Card.new(request_options, http_client)
    end

    # @return [CardToken] resource for tokenising card data server-side
    def card_token
      CardToken.new(request_options, http_client)
    end

    # @return [Customer] resource for managing customer records
    def customer
      Customer.new(request_options, http_client)
    end

    # @return [DisbursementRefund] resource for refunding advanced-payment disbursements
    def disbursement_refund
      DisbursementRefund.new(request_options, http_client)
    end

    # @return [User] resource for retrieving the authenticated user's profile
    def user
      User.new(request_options, http_client)
    end

    # @return [IdentificationType] resource for listing supported ID document types
    def identification_type
      IdentificationType.new(request_options, http_client)
    end

    # @return [MerchantOrder] resource for grouping payments into merchant orders
    def merchant_order
      MerchantOrder.new(request_options, http_client)
    end

    # @return [Payment] resource for creating, searching, and managing payments
    def payment
      Payment.new(request_options, http_client)
    end

    # @return [PaymentMethods] resource for listing available payment methods
    def payment_methods
      PaymentMethods.new(request_options, http_client)
    end

    # @return [Preference] resource for Checkout Pro payment preferences
    def preference
      Preference.new(request_options, http_client)
    end

    # @return [Refund] resource for issuing full or partial refunds on payments
    def refund
      Refund.new(request_options, http_client)
    end

    # @return [Preapproval] resource for managing recurring subscriptions
    def preapproval
      Preapproval.new(request_options, http_client)
    end

    # @return [PreapprovalPlan] resource for managing subscription plan templates
    def preapproval_plan
      PreapprovalPlan.new(request_options, http_client)
    end

    # @return [Order] resource for creating and managing orders (Checkout API)
    def order
      Order.new(request_options, http_client)
    end

    # @return [OrderTransaction] resource for managing transactions within an order
    def order_transaction
      OrderTransaction.new(request_options, http_client)
    end

    # @param value [String] OAuth access token
    # @raise [TypeError] if value is not a String
    def access_token=(value)
      raise TypeError, 'Param access_token must be a String' unless value.is_a?(String)

      @access_token = value
    end

    # @param value [HttpClient] HTTP transport implementation
    # @raise [TypeError] if value is not an {HttpClient} instance
    def http_client=(value)
      raise TypeError, 'Param http_client must be a implementation of HttpClient' unless value.is_a?(HttpClient)

      @http_client = value
    end

    # @param value [RequestOptions] request configuration object
    # @raise [TypeError] if value is not a {RequestOptions} instance
    def request_options=(value)
      raise TypeError, 'Param request_options must be a RequestOptions object' unless value.is_a?(RequestOptions)

      @request_options = value
    end

    # Returns the current request options, ensuring the access token is set.
    #
    # If the stored request options have a nil access token, the SDK's
    # access token is injected automatically.
    #
    # @return [RequestOptions] current request configuration
    def request_options
      @request_options.access_token = @access_token if @request_options.access_token.nil?
      @request_options
    end
  end
end

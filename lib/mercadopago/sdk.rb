# typed: true
# frozen_string_literal: true

module Mercadopago
  class SDK
    attr_reader :access_token, :http_client

    def initialize(access_token, http_client: nil, request_options: nil)
      self.access_token = access_token
      self.http_client = http_client.nil? ? HttpClient.new : http_client
      self.request_options = request_options.nil? ? RequestOptions.new(access_token: access_token) : request_options
    end

    def advanced_payment
      AdvancedPayment.new(request_options, http_client)
    end

    def card
      Card.new(request_options, http_client)
    end

    def card_token
      CardToken.new(request_options, http_client)
    end

    def customer
      Customer.new(request_options, http_client)
    end

    def disbursement_refund
      DisbursementRefund.new(request_options, http_client)
    end

    def user
      User.new(request_options, http_client)
    end

    def identification_type
      IdentificationType.new(request_options, http_client)
    end

    def merchant_order
      MerchantOrder.new(request_options, http_client)
    end

    def payment
      Payment.new(request_options, http_client)
    end

    def payment_methods
      PaymentMethods.new(request_options, http_client)
    end

    def preference
      Preference.new(request_options, http_client)
    end

    def refund
      Refund.new(request_options, http_client)
    end

    def preapproval
      Preapproval.new(request_options, http_client)
    end

    def preapproval_plan
      PreapprovalPlan.new(request_options, http_client)
    end

    def order
      Order.new(request_options, http_client)
    end

    def order_transaction
      OrderTransaction.new(request_options, http_client)
    end


    def access_token=(value)
      raise TypeError, 'Param access_token must be a String' unless value.is_a?(String)

      @access_token = value
    end

    def http_client=(value)
      raise TypeError, 'Param http_client must be a implementation of HttpClient' unless value.is_a?(HttpClient)

      @http_client = value
    end

    def request_options=(value)
      raise TypeError, 'Param request_options must be a RequestOptions object' unless value.is_a?(RequestOptions)

      @request_options = value
    end

    def request_options
      @request_options.access_token = @access_token if @request_options.access_token.nil?
      @request_options
    end
  end
end

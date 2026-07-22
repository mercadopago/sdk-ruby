# typed: false
# frozen_string_literal: true

module Mercadopago
  # Manages refunds on individual disbursements within an {AdvancedPayment}.
  #
  # In marketplace split-payment scenarios each seller receives a
  # separate disbursement. This resource allows refunding one specific
  # disbursement (full or partial) or all disbursements at once.
  class DisbursementRefund < MPBase
    # Lists all refunds for an advanced payment.
    #
    # @param advanced_payment_id [Integer, String] advanced payment ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with an array of refunds
    def list(advanced_payment_id, request_options: nil)
      _get(uri: "/v1/advanced_payments/#{_path_param(advanced_payment_id)}/refunds", request_options: nil)
    end

    # Refunds all disbursements of an advanced payment at once.
    #
    # @param advanced_payment_id [Integer, String] advanced payment ID
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with refund details
    def create_all(advanced_payment_id, request_options: nil)
      _post(uri: "/v1/advanced_payments/#{_path_param(advanced_payment_id)}/refunds", request_options: request_options)
    end

    # Refunds a single disbursement (full or partial).
    #
    # Omit +amount+ for a full refund of the disbursement, or pass a
    # specific amount for a partial refund.
    #
    # @param advanced_payment_id [Integer, String] advanced payment ID
    # @param disbursement_id [Integer, String] disbursement ID within the advanced payment
    # @param amount [Float, nil] partial refund amount; nil for a full refund
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with the created refund
    def create(advanced_payment_id, disbursement_id, amount: nil, request_options: nil)
      disbursement_refund_data = amount.nil? ? nil : { amount: amount }

      _post(uri: "/v1/advanced_payments/#{_path_param(advanced_payment_id)}/disbursements/#{_path_param(disbursement_id)}/refunds",
            data: disbursement_refund_data, request_options: request_options)
    end
  end
end

# typed: false
# frozen_string_literal: true

module Mercadopago
  #     ###
  #     #Access to Advanced Payments Refunds

  class DisbursementRefund < MPBase
    def list(advanced_payment_id, request_options: nil)
      _get(uri: "/v1/advanced_payments/#{advanced_payment_id}/refunds", request_options: nil)
    end

    def create_all(advanced_payment_id, request_options: nil)
      _post(uri: "/v1/advanced_payments/#{advanced_payment_id}/refunds", request_options: request_options)
    end

    def create(advanced_payment_id, disbursement_id, amount: nil, request_options: nil)
      disbursement_refund_data = amount.nil? ? nil : { amount: amount }

      _post(uri: "/v1/advanced_payments/#{advanced_payment_id}/disbursements/#{disbursement_id}/refunds",
            data: disbursement_refund_data, request_options: request_options)
    end
  end
end

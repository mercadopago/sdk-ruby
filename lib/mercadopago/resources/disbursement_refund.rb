# typed: false
# frozen_string_literal: true

module Mercadopago
  #     ###
  #     #Access to Advanced Payments Refunds

  class DisbursementRefund < MPBase
    def search(advanced_payment_id, request_options: nil)
      _get(uri: "/v1/advanced_payments/#{advanced_payment_id}/refunds", request_options: nil)
    end

    def create_all(advanced_payment_id, disbursement_refund_object, request_options: nil)
      unless disbursement_refund_object.is_a?(Hash)
        raise TypeError,
              'Param disbursement_refund_object must be a Hash'
      end

      _post(uri = "/v1/advanced_payments/#{advanced_payment_id}/refunds", data: disbursement_refund_object,
                                                                          request_options: request_options)
    end

    def create(advanced_payment_id, disbursement_id, amount, request_options: nil)
      raise TypeError, 'Param advanced_payment_object must be a Hash' unless advanced_payment_object.is_a?(Hash)

      disbursement_refund_object = { "amount": amount }

      _post(uri = "/v1/advanced_payments/#{advanced_payment_id}/disbursements/#{disbursement_id}/refunds",
            data: disbursement_refund_object, request_options: request_options)
    end

    def save(advanced_payment_id, disbursement_id, disbursement_refund_object, request_options: nil)
      unless advanced_payment_object.is_a?(Hash)
        raise TypeError,
              'Param disbursement_refund_object must be a Hash'
      end

      _post(uri = "/v1/advanced_payments/#{advanced_payment_id}/disbursements/#{disbursement_id}/refunds",
            data: disbursement_refund_object, request_options: request_options)
    end
  end
end

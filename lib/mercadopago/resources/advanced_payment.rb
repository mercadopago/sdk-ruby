# typed: false
# frozen_string_literal: true

module Mercadopago
  ###
  # Access to Advanced Payments

  class AdvancedPayment < MPBase
    def search(filters = nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.is_a?(Hash)

      _get(uri: '/v1/advanced_payments/search', filters: filters, request_options: request_options)
    end

    def get(id, request_options: nil)
      _get(uri: "/v1/advanced_payments/#{id}", request_options: request_options)
    end

    def create(advanced_payment_object, request_options: nil)
      raise TypeError, 'Param advanced_payment_object must be a Hash' unless advanced_payment_object.is_a?(Hash)

      _post(uri: '/v1/advanced_payments', data: advanced_payment_object, request_options: request_options)
    end

    def capture(id, request_options: nil)
      capture_object = { "capture": true }
      _put(uri: "/v1/advanced_payments/#{id}", data: capture_object, request_options: request_options)
    end

    def update(id, advanced_payment_object, request_options: nil)
      raise TypeError, 'Param advanced_payment_object must be a Hash' unless advanced_payment_object.is_a?(Hash)

      _put(uri: "/v1/advanced_payments/#{id}", data: advanced_payment_object, request_options: request_options)
    end

    def cancel(id, request_options: nil)
      cancel_object = { "status": 'cancelled' }
      _put(uri: "/v1/advanced_payments/#{id}", data: cancel_object, request_options: request_options)
    end

    def update_release_date(id, release_date, request_options: nil)
      disbursement_object = { "money_release_date": release_date.strftime('%Y-%m-%d %H:%M:%S.%f') }
      _post(uri = "/v1/advanced_payments/#{id}/disburses", data: disbursement_object,
                                                           request_options: request_options)
    end
  end
end

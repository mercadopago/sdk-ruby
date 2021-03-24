# typed: false
# frozen_string_literal: true

module Mercadopago
  ###
  # Access to Advanced Payments

  class AdvancedPayment < MPBase
    def search(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/v1/advanced_payments/search', filters: filters, request_options: request_options)
    end

    def get(advanced_payment_id, request_options: nil)
      _get(uri: "/v1/advanced_payments/#{advanced_payment_id}", request_options: request_options)
    end

    def create(advanced_payment_data, request_options: nil)
      raise TypeError, 'Param advanced_payment_data must be a Hash' unless advanced_payment_data.is_a?(Hash)

      _post(uri: '/v1/advanced_payments', data: advanced_payment_data, request_options: request_options)
    end

    def capture(advanced_payment_id, request_options: nil)
      capture_data = { capture: true }
      _put(uri: "/v1/advanced_payments/#{advanced_payment_id}", data: capture_data, request_options: request_options)
    end

    def update(advanced_payment_id, advanced_payment_data, request_options: nil)
      raise TypeError, 'Param advanced_payment_data must be a Hash' unless advanced_payment_data.is_a?(Hash)

      _put(uri: "/v1/advanced_payments/#{advanced_payment_id}", data: advanced_payment_data,
           request_options: request_options)
    end

    def cancel(advanced_payment_id, request_options: nil)
      cancel_data = { status: 'cancelled' }
      _put(uri: "/v1/advanced_payments/#{advanced_payment_id}", data: cancel_data, request_options: request_options)
    end

    def update_release_date(advanced_payment_id, release_date, request_options: nil)
      disbursement_data = { money_release_date: release_date.strftime('%Y-%m-%d %H:%M:%S.%f') }
      _post(uri: "/v1/advanced_payments/#{advanced_payment_id}/disburses", data: disbursement_data,
            request_options: request_options)
    end
  end
end

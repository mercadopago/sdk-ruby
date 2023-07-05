# typed: true
# frozen_string_literal: true

module Mercadopago
  ###
  # This class provides the methods to access the API
  # that will allow you to create your own plan of subscription experience on your website.

  # From basic to advanced configurations, you control the whole experience.

  # [Click here for more infos](https://www.mercadopago.com.ar/developers/es/reference/subscriptions/_preapproval_plan/post)

  class PreapprovalPlan < MPBase
    def search(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/preapproval_plan/search', filters: filters, request_options: request_options)
    end

    def get(preapproval_plan_id, request_options: nil)
      _get(uri: "/preapproval_plan/#{preapproval_plan_id}", request_options: request_options)
    end

    def create(preapproval_plan_data, request_options: nil)
      raise TypeError, 'Param preapproval_plan_data must be a Hash' unless preapproval_plan_data.is_a?(Hash)

      _post(uri: '/preapproval_plan/', data: preapproval_plan_data, request_options: request_options)
    end

    def update(preapproval_plan_id, preapproval_plan_data, request_options: nil)
      raise TypeError, 'Param preapproval_plan_data must be a Hash' unless preapproval_plan_data.is_a?(Hash)

      _put(uri: "/preapproval_plan/#{preapproval_plan_id}", data: preapproval_plan_data, request_options: request_options)
    end
  end
end

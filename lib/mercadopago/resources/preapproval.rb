# typed: true
# frozen_string_literal: true

module Mercadopago
  ###
  # This class provides the methods to access the API
  # that will allow you to create your own subscription experience on your website.

  # From basic to advanced configurations, you control the whole experience.

  # [Click here for more infos](https://www.mercadopago.com.ar/developers/es/reference/subscriptions/_preapproval/post)

  class Preapproval < MPBase
    def search(filters: nil, request_options: nil)
      raise TypeError, 'Param filters must be a Hash' unless filters.nil? || filters.is_a?(Hash)

      _get(uri: '/preapproval/search', filters: filters, request_options: request_options)
    end

    def get(preapproval_id, request_options: nil)
      _get(uri: "/preapproval/#{preapproval_id}", request_options: request_options)
    end

    def create(preapproval_data, request_options: nil)
      raise TypeError, 'Param preapproval_data must be a Hash' unless preapproval_data.is_a?(Hash)

      _post(uri: '/preapproval/', data: preapproval_data, request_options: request_options)
    end

    def update(preapproval_id, preapproval_data, request_options: nil)
      raise TypeError, 'Param preapproval_data must be a Hash' unless preapproval_data.is_a?(Hash)

      _put(uri: "/preapproval/#{preapproval_id}", data: preapproval_data, request_options: request_options)
    end
  end
end

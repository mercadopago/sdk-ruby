# typed: true
# frozen_string_literal: true

module Mercadopago
  ###
  # Access to Identification Types

  class IdentificationType < MPBase
    def get(request_options: nil)
      _get(uri: '/v1/identification_types', request_options: request_options)
    end
  end
end

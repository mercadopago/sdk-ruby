# typed: true
# frozen_string_literal: true

module Mercadopago
  ###
  # Access to Users

  class User < MPBase
    def get(request_options: nil)
      _get(uri: '/users/me', request_options: request_options)
    end
  end
end

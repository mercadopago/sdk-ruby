# typed: true
# frozen_string_literal: true

module Mercadopago
  # Lists the identification document types accepted in each country
  # (e.g. CPF in Brazil, DNI in Argentina).
  #
  # The returned list is used to populate identification-type selectors
  # in checkout forms and to validate payer documents.
  #
  # @see https://www.mercadopago.com/developers/en/reference/identification_types/_identification_types/get
  class IdentificationType < MPBase
    # Retrieves all identification types available for the caller's country.
    #
    # @param request_options [RequestOptions, nil] per-call configuration override
    # @return [Hash{Symbol => Object}] +:status+ and +:response+ with an array of identification types
    def get(request_options: nil)
      _get(uri: '/v1/identification_types', request_options: request_options)
    end
  end
end

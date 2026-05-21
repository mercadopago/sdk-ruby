# Mercado Pago — Create Order with PSE (Pagos Seguros en Línea — Colombia).
#
# PSE is Colombia's standard online bank-transfer payment method. The integrator
# initiates the transaction with payment_method.id = "pse" and type = "bank_transfer",
# and must specify the buyer's bank via financial_institution.
#
# Required PSE-specific fields:
#   - payment_method.id                       = "pse" (fixed)
#   - payment_method.type                     = "bank_transfer" (fixed)
#   - payment_method.financial_institution    = PSE bank code (see table below)
#   - currency                                = "COP" (Colombia only)
#   - payer.entity_type                       = "individual" or "association"
#   - payer.identification.type               = "CC", "NIT", etc. (Colombian doc type)
#   - additional_info.payer.ip_address        (required by risk engine)
#   - config.online.callback_url              (URL the bank redirects to after authorization)
#
# Most-used PSE bank codes (full catalog via MP API):
#   Bancolombia ........... 1007
#   Davivienda ............ 1051
#   Banco de Bogotá ....... 1001
#   BBVA Colombia ......... 1013
#   Banco Popular ......... 1002
#   Scotiabank Colpatria .. 1019
#
# Reference: https://www.mercadopago.com.co/developers/es/docs

require_relative '../../lib/mercadopago'


sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

def create_pse_order(sdk)
  request = {
    type: 'online',
    processing_mode: 'automatic',
    total_amount: '50000.00',
    currency: 'COP',
    external_reference: 'ref_pse_12345',
    transactions: {
      payments: [
        {
          amount: '50000.00',
          # PSE payment: id="pse", type="bank_transfer", financial_institution = bank code.
          payment_method: {
            id: 'pse',
            type: 'bank_transfer',
            financial_institution: '1007' # Bancolombia
          }
        }
      ]
    },
    # Payer: entity_type + Colombian identification (CC/NIT) required for PSE.
    payer: {
      entity_type: 'individual',
      email: '<PAYER_EMAIL>',
      first_name: '<FIRST_NAME>',
      last_name: '<LAST_NAME>',
      identification: {
        type: 'CC',
        number: '<PAYER_DOC_NUMBER>'
      }
    },
    # additional_info.payer.ip_address — required by MP's risk engine for PSE.
    additional_info: {
      payer: {
        ip_address: '<CLIENT_IP>'
      }
    },
    # callback_url — where the bank redirects the buyer after authorization.
    config: {
      online: {
        callback_url: '<CALLBACK_URL>'
      }
    }
  }

  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  result = sdk.order.create(request, request_options: custom_request_options)
  order = result[:response]
  puts order

rescue MercadoPago::MPApiException => e
  puts "Status code: #{e.api_response.status_code}"
  puts "Content: #{e.api_response.content}"
rescue StandardError => e
  puts e.message
end

create_pse_order(sdk)

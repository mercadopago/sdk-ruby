require_relative '../../lib/mercadopago'


sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

def create_order(sdk)
  # Create Order
  request = {
    type: 'online',
    total_amount: '1000.00',
    external_reference: 'ext_ref_1234',
    capture_mode: 'automatic',
    transactions: {
      payments: [
        {
          amount: '1000.00',
          payment_method: {
            id: 'master',
            type: 'credit_card',
            token: '<CARD_TOKEN>',
            installments: 1,
            statement_descriptor: 'Store name'
          }
        }
      ]
    },
    processing_mode: 'automatic',
    description: 'some description',
    payer: {
      email: '<PAYER_EMAIL>',
      first_name: 'John',
      last_name: 'Doe',
      identification: {
        type: 'CPF',
        number: '00000000000'
      }
    }
  }

  # Set Custom Headers
  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  # Send Request
  result = sdk.order.create(request, request_options: custom_request_options)
  order = result[:response]
  puts order

rescue MercadoPago::MPApiException => e
  puts "Status code: #{e.api_response.status_code}"
  puts "Content: #{e.api_response.content}"
rescue StandardError => e
  puts e.message
end

create_order(sdk)

require_relative '../../../lib/mercadopago'

sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

def create_order_transaction(sdk)
  # Create Transaction Order
  request =
    { payments:
        [{
          amount: '10.00',
          payment_method: {
            id: 'pix',
            type: 'bank_transfer'
          }
        }] }

  # Set Custom Headers
  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  # Send Request
  result = sdk.order_transaction.create(request, request_options: custom_request_options)
  order = result[:response]
  puts order['id']

rescue Mercadopago::MercadoPagoError => e
  puts "Status code: #{e.status_code}"
  puts "Error: #{e.error}; causes: #{e.causes}"
rescue StandardError => e
  puts e.message
end

create_order_transaction(sdk)

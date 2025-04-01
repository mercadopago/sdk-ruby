require_relative '../../../lib/mercadopago'

sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

def update_order_transaction(sdk)
  # Create Transaction Order Update
  request = {
    payment_method: {
      installments: 5
    }
  }

  # Set Custom Headers
  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  # Send Request
  result = sdk.order_transaction.update('<ORDER_ID>', '<TRANSACTION_ID>', request, request_options: custom_request_options)
  order = result[:response]
  puts order
rescue MercadoPago::MPApiException => e
  puts "Status code: #{e.api_response.status_code}"
  puts "Content: #{e.api_response.content}"
rescue StandardError => e
  puts e.message
end

update_order_transaction(sdk)

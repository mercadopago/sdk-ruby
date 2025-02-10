require_relative '../../lib/mercadopago'


sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

def cancel_order(sdk)

  order_id = '<ORDER_ID>'

  # Set Custom Headers
  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  # Send Request
  result = sdk.order.cancel(order_id, request_options: custom_request_options)
  order = result[:response]
  puts result[:status]
  puts order['id']

rescue MercadoPago::MPApiException => e
  puts "Status code: #{e.api_response.status_code}"
  puts "Content: #{e.api_response.content}"
rescue StandardError => e
  puts e.message
end

cancel_order(sdk)

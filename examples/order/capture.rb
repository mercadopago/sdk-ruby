require_relative '../../lib/mercadopago'


sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

def capture_order(sdk)

  order_id = '<ORDER_ID>'

  # Set Custom Headers
  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  # Send Request
  result = sdk.order.capture(order_id, request_options: custom_request_options)
  order = result[:response]
  puts result[:status]
  puts order['id']

rescue Mercadopago::MercadoPagoError => e
  puts "Status code: #{e.status_code}"
  puts "Error: #{e.error}; causes: #{e.causes}"
rescue StandardError => e
  puts e.message
end

capture_order(sdk)

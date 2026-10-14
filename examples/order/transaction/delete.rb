require_relative '../../../lib/mercadopago'

sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

def delete_order_transaction(sdk)
  # Set Custom Headers
  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  # Send Request
  result = sdk.order_transaction.delete('<ORDER_ID>', '<TRANSACTION_ID>', request_options: custom_request_options)
  puts result[:status]
rescue Mercadopago::MercadoPagoError => e
  puts "Status code: #{e.status_code}"
  puts "Error: #{e.error}; causes: #{e.causes}"
rescue StandardError => e
  puts e.message
end

delete_order_transaction(sdk)

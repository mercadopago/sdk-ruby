require_relative '../../lib/mercadopago'

sdk = Mercadopago::SDK.new('<YOUR_ACCESS_TOKEN>')

# List available Point devices
devices = sdk.point.get_devices
puts "Devices: #{devices[:response]}"

# Create a payment intent on a specific device
device_id = '<YOUR_DEVICE_ID>'
payment_intent_data = {
  amount: 1500,
  description: 'Product purchase',
  payment: {
    installments: 1,
    type: 'credit_card'
  }
}

result = sdk.point.create(device_id, payment_intent_data)
puts "Payment intent created: #{result[:response]}"

# Retrieve the payment intent status
payment_intent_id = result[:response]['id']
status = sdk.point.get(payment_intent_id)
puts "Payment intent status: #{status[:response]}"

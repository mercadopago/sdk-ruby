require_relative '../../lib/mercadopago'

sdk = Mercadopago::SDK.new('<YOUR_ACCESS_TOKEN>')

# Search chargebacks by payment ID
result = sdk.chargeback.search(filters: { payment_id: '<PAYMENT_ID>' })
puts "Chargebacks: #{result[:response]}"

# Get a specific chargeback by ID
if result[:response]['results']&.any?
  chargeback_id = result[:response]['results'].first['id']
  chargeback = sdk.chargeback.get(chargeback_id)
  puts "Chargeback details: #{chargeback[:response]}"
end

require_relative '../../lib/mercadopago'

sdk = Mercadopago::SDK.new('<YOUR_ACCESS_TOKEN>')

# Search invoices for a subscription
result = sdk.invoice.search(filters: { preapproval_id: '<YOUR_PREAPPROVAL_ID>', limit: 10 })
puts "Invoices: #{result[:response]}"

# Get a specific invoice by ID
if result[:response]['results']&.any?
  invoice_id = result[:response]['results'].first['id']
  invoice = sdk.invoice.get(invoice_id)
  puts "Invoice details: #{invoice[:response]}"
end

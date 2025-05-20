require_relative '../../lib/mercadopago'

sdk = Mercadopago::SDK.new('YOUR_ACCESS_TOKEN')

def create_preference(sdk)
  data = {
    items: [
      {
        title: 'Test Item',
        quantity: 1,
        unit_price: 10.0
      }
    ],
    notification_url: 'https://webhook.site/your-dummy-url'
  }

  preference = sdk.preference.create(data)
  puts preference
rescue MercadoPago::MPApiException => e
  puts "Status code: #{e.api_response.status_code}"
  puts "Content: #{e.api_response.content}"
rescue StandardError => e
  puts e.message
end

create_preference(sdk)

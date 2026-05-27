require_relative '../../lib/mercadopago'

sdk = Mercadopago::SDK.new('<YOUR_ACCESS_TOKEN>')

# Step 1: Build the authorization URL and redirect the seller to it
auth_url = sdk.oauth.get_authorization_url(
  '<YOUR_APP_ID>',
  'https://yourapp.com/callback',
  '<UNIQUE_CSRF_STATE>'
)
puts "Redirect seller to: #{auth_url}"

# Step 2: After the seller authorizes, exchange the code for tokens
oauth_data = {
  client_secret: '<YOUR_ACCESS_TOKEN>',
  code: '<AUTHORIZATION_CODE_FROM_CALLBACK>',
  redirect_uri: 'https://yourapp.com/callback',
  grant_type: 'authorization_code'
}

result = sdk.oauth.create(oauth_data)
puts "Token created: #{result[:response]}"

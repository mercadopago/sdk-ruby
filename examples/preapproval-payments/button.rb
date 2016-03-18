require 'rubygems'
require 'rack'
$LOAD_PATH << '../../lib'
require 'mercadopago.rb'

class Button

  def call(env)
  mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')
  preapprovalPayment_data = Hash[
    "payer_email" => "my_customer@my_site.com",
      "back_url" => "http://www.my_site.com",
      "reason" => "Monthly subscription to premium package",
      "external_reference" => "OP-1234",
      "auto_recurring" => Hash[
          "frequency" => 1,
          "frequency_type" => "months",
          "transaction_amount" => 60,
          "currency_id" => "BRL",
          "start_date" => "2012-12-10T14:58:11.778-03:00",
          "end_date" => "2013-06-10T14:58:11.778-03:00"
      ]
  ]

  preapprovalPayment = mp.create_preapproval_payment(preapprovalPayment_data)

  html =  '<!doctype html>
      <html>
        <head>
          <title>MercadoPago SDK - Create Preapproval Payment and Show Subscription Example</title>
        </head>
      <body>
        <a href="' + preapprovalPayment['response']['init_point'] + '" name="MP-Checkout" class="orange-ar-m-sq-arall">Pay</a>
        <script type="text/javascript" src="//resources.mlstatic.com/mptools/render.js"></script>
      </body>
      </html>'

  return [200, {'Content-Type' => 'text/html'}, [html]]
  end
end

Rack::Handler::WEBrick.run(Button.new, port: 9000)

require 'rubygems'
require 'rack'
$LOAD_PATH << '../../../lib'
require 'mercadopago.rb'

class Button
	
  def call(env)
	mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')
	preferenceData = {"items" => ["title"=>"testCreate", "quantity"=>1, "unit_price"=>10.2, "currency_id"=>"ARS"]}
	preference = mp.create_preference(preferenceData)
	
	html =  '<!doctype html>
			<html>
				<head>
					<title>MercadoPago SDK - Create Preference and Show Checkout Example</title>
				</head>
			<body>
				<a href="' + preference['response']['init_point'] + '" name="MP-Checkout" class="orange-ar-m-sq-arall">Pay</a>
				<script type="text/javascript" src="//resources.mlstatic.com/mptools/render.js"></script>
			</body>
			</html>'
	
	return [200, {'Content-Type' => 'text/html'}, [html]]
  end
end

Rack::Handler::WEBrick.run(Button.new, :Port => 9000)

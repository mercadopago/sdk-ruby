require 'rubygems'
require 'rack'

class MD5
  def call(env)
	# Get your Mercadopago credentials (CLIENT_ID and CLIENT_SECRET):
		#     Argentina: https://www.mercadopago.com/mla/herramientas/aplicaciones 
		#     Brasil: https://www.mercadopago.com/mlb/ferramentas/aplicacoes

	# Define item data according to form
	client_id = "CLIENT_ID"
	client_secret = "CLIENT_SECRET"
	
	data =  client_id
	data +=	client_secret
	data +=	"1"         		# item_quantity
	data +=	"ARS"               # item_currency_id
	data +=	"10";               # item_unit_price

	# Get md5 hash
	md5 = Digest::MD5.hexdigest(data)
	
	html =  '<html>
			<head>
				<title>Checkout button with MD5 hash - Form</title>
			</head>
				<body>
				<form action="https://www.mercadopago.com/beta/checkout/md5" method="post" enctype="application/x-www-form-urlencoded" target="">
				<input type="hidden" name="client_id" value="' + client_id + '"/>
				<input type="hidden" name="md5" value="' + md5 + '"/>
				
				<!-- Datos obligatorios del item -->
				<input type="hidden" name="item_title" value="sdk-ruby"/>
				<input type="hidden" name="item_quantity" value="1"/>
				<input type="hidden" name="item_currency_id" value="ARS"/>
				<input type="hidden" name="item_unit_price" value="10"/>
				
				<button type="submit" class="lightblue-rn-m-tr-arall" name="MP-Checkout">Pagar</button>
			</form>
			
			<!-- More info about render.js: https://developers.mercadopago.com -->
			<script type="text/javascript" src="http://mp-tools.mlstatic.com/buttons/render.beta.js"></script>
			
			</body>
			</html>'
	
	return [200, {'Content-Type' => 'text/html'}, [html]]
  end
end

Rack::Handler::WEBrick.run(MD5.new, :Port => 9000)

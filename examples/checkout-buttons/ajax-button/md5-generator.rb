require 'rubygems'
require 'rack'

class MD5
  def call(env)
	# Get your Mercadopago credentials (CLIENT_ID and CLIENT_SECRET):
		#     Argentina: https://www.mercadopago.com/mla/herramientas/aplicaciones 
		#     Brasil: https://www.mercadopago.com/mlb/ferramentas/aplicacoes

	# Define item data according to form
	client_id = "CLIENT_ID"
	client_secret = "CLIENt_SECRET"
	
	data =  client_id
	data +=	client_secret
	data +=	"1"         		# item_quantity
	data +=	"ARS"               # item_currency_id
	data +=	"10";               # item_unit_price

	# Get md5 hash			
	output = '{"md5":"' + Digest::MD5.hexdigest(data) + '"}'
	
	return [200, {'Content-Type' => 'text/html'}, [output]]
  end
end

Rack::Handler::WEBrick.run(MD5.new, :Port => 9000)

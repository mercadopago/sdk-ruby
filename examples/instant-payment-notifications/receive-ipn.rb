require 'rubygems'
require 'rack'
$LOAD_PATH << '../../lib'
require 'mercadopago.rb'

class IPN
  def call(env)
    mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')

    # Get the payment reported by the IPN. Glossary of attributes response in https://developers.mercadopago.com
    payment_info = mp.get_payment_info('ID')

    html = []

    html << payment_info['response'].inspect

    return [200, { 'Content-Type' => 'text/html' }, html]
  end
end

Rack::Handler::WEBrick.run(IPN.new, port: 9000)

# frozen_string_literal: true

require 'rubygems'
require 'rack'
$LOAD_PATH << '../../lib'
require 'mercadopago'

class IPN
  def call(_env)
    mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')

    # Get the payment reported by the IPN. Glossary of attributes response in https://developers.mercadopago.com
    payment_info = mp.get_payment_info('ID')

    html = ''
    # Show payment information
    html = if payment_info['status'] == 200
             payment_info['response'].inspect
           else
             payment_info['response'].inspect
           end

    [200, { 'Content-Type' => 'text/html' }, [html]]
  end
end

Rack::Handler::WEBrick.run(IPN.new, Port: 9000)

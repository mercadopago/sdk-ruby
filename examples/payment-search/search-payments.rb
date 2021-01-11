# typed: false
# frozen_string_literal: true

require 'rubygems'
require 'rack'
$LOAD_PATH << '../../lib'
require 'mercadopago'

class IPN
  def call(_env)
    mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')

    # Sets the filters you want
    filters = Hash['external_reference' => 'Bill001']

    # Search payment data according to filters
    searchResult = mp.search_payment(filters)

    # Show payment information
    html = searchResult.inspect

    [200, { 'Content-Type' => 'text/html' }, [html]]
  end
end

Rack::Handler::WEBrick.run(IPN.new, Port: 9000)

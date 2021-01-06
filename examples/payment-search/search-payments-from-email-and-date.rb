# frozen_string_literal: true

require 'rubygems'
require 'rack'
$LOAD_PATH << '../../lib'
require 'mercadopago'

class IPN
  def call(_env)
    mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')

    # Sets the filters you want
    filters = Hash['payer.email' => 'mail02@mail02.com', 'begin_date' => '2011-01-01T00:00:00Z',
                   'end_date' => '2011-02-01T00:00:00Z']

    # Search payment data according to filters
    searchResult = mp.search_payment(filters)

    # Show payment information
    html = searchResult.inspect

    [200, { 'Content-Type' => 'text/html' }, [html]]
  end
end

Rack::Handler::WEBrick.run(IPN.new, Port: 9000)

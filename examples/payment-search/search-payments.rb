require 'rubygems'
require 'rack'
$LOAD_PATH << '../../lib'
require 'mercadopago.rb'

class IPN
  def call(env)
    mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')

    # Sets the filters you want
    filters = { "site_id" => "MLA", "external_reference" => "Bill001" }

    # Search payment data according to filters
    searchResult = mp.search_payment(filters)

    # Show payment information
    html = searchResult.inspect

    return [200, { 'Content-Type' => 'text/html' }, [html]]
  end
end

Rack::Handler::WEBrick.run(IPN.new, port: 9000)

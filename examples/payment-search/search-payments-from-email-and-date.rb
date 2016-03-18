require 'rubygems'
require 'rack'
$LOAD_PATH << '../../lib'
require 'mercadopago.rb'

class IPN
  def call(env)
    mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')

    # Sets the filters you want
    filters = {
      "payer_email" => "mail02@mail02.com%20mail01@mail01.com",
      "begin_date" => "2011-01-01T00:00:00Z",
      "end_date" => "2011-02-01T00:00:00Z"
    }

    # Search payment data according to filters
    searchResult = mp.search_payment(filters)

    # Show payment information
    html = searchResult.inspect

    return [200, { 'Content-Type' => 'text/html' }, [html]]
  end
end

Rack::Handler::WEBrick.run(IPN.new, port: 9000)

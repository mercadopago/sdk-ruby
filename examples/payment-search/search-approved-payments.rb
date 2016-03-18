require 'rubygems'
require 'rack'
$LOAD_PATH << '../../lib'
require 'mercadopago.rb'

class IPN
  def call(env)
    mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')

    # Sets the filters you want
    filters = {
      "range" => "date_created",
      "begin_date" => "NOW-1MONTH",
      "end_date" => "NOW",
      "status" => "approved",
      "operation_type" => "regular_payment"
    }

    # Search payment data according to filters
    searchResult = mp.search_payment(filters)

    # Show payment information
    html = searchResult.inspect

    return [200, { 'Content-Type' => 'text/html' }, [html]]
  end
end

Rack::Handler::WEBrick.run(IPN.new, port: 9000)

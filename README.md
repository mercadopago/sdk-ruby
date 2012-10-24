# Mercadopago SDK module for Payments integration

* [Usage](#usage)
* [Using Mercadopago Checkout](#checkout)
* [Using Mercadopago Payment collection](#payments)

<a name="usage"></a>
### Usage:

1. Copy lib/mercadopago.rb to your project desired folder.
2. Copy lib/cacert.pem to the same folder (for SSL access to MercadoPago APIs).

* Get your credentials at [Mercadopago Developers Site](https://developers.mercadopago.com/beta/api-de-checkout#get-credentials).
* Replace your CLIENT_ID and CLIENT_SECRET.

```ruby
require 'mercadopago.rb'

$mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')
```

<a name="checkout"></a>
### Using Mercadopago Checkout

Get an existent Checkout preference:

```ruby
preference = $mp.get_preference('PREFERENCE_ID')

puts $preferenceResult
```

Create a Checkout preference:

```ruby
preferenceData = Hash["items" => Array(Array["title"=>"testCreate", "quantity"=>1, "unit_price"=>10.2, "currency_id"=>"ARS"])]
	
preference = $mp.create_preference(preferenceData)

puts preference
```

Update an existent Checkout preference:

```ruby
preferenceDataToUpdate = Hash["items" => Array(Array["title"=>"testUpdated", "quantity"=>1, "unit_price"=>2])]

preferenceUpdate = $mp.update_preference("PREFERENCE_ID", preferenceDataToUpdate)

puts preferenceUpdate
```

<a name="payments"></a>
### Using Mercadopago Payment

Searching:

```ruby    
filters = Array["id"=>null, "site_id"=>null, "external_reference"=>null]

searchResult = $mp.search_payment(filters)

puts searchResult
```

Receiving IPN notification:

```ruby

paymentInfo = $mp.get_payment_info("ID")

puts paymentInfo
```

Cancel (only for pending payments):

```ruby
result = $mp.cancel_payment("ID");

// Show result
puts result
```

Refund (only for accredited payments):

```ruby
result = $mp.refund_payment("ID");

// Show result
puts result
```
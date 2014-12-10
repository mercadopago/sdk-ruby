# MercadoPago SDK module for Payments integration

* [Usage](#usage)
* [Using MercadoPago Checkout](#checkout)
* [Using MercadoPago Payment collection](#payments)

<a name="usage"></a>
## Usage:

1. Copy lib/mercadopago.rb to your project desired folder.
2. Copy lib/cacert.pem to the same folder (for SSL access to MercadoPago APIs).

* Get your **CLIENT_ID** and **CLIENT_SECRET** in the following address:
    * Argentina: [https://www.mercadopago.com/mla/herramientas/aplicaciones](https://www.mercadopago.com/mla/herramientas/aplicaciones)
    * Brazil: [https://www.mercadopago.com/mlb/ferramentas/aplicacoes](https://www.mercadopago.com/mlb/ferramentas/aplicacoes)
    * México: [https://www.mercadopago.com/mlm/herramientas/aplicaciones](https://www.mercadopago.com/mlm/herramientas/aplicaciones)
    * Venezuela: [https://www.mercadopago.com/mlv/herramientas/aplicaciones](https://www.mercadopago.com/mlv/herramientas/aplicaciones)
    * Colombia: [https://www.mercadopago.com/mco/herramientas/aplicaciones](https://www.mercadopago.com/mco/herramientas/aplicaciones)

```ruby
require 'mercadopago.rb'

$mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')
```

### Get your Access Token:

```ruby
$accessToken = $mp.getAccessToken()

puts (accessToken)
```

<a name="checkout"></a>
## Using MercadoPago Checkout

### Get an existent Checkout preference:

```ruby
preference = $mp.get_preference('PREFERENCE_ID')

puts $preferenceResult
```

### Create a Checkout preference:

```ruby
preferenceData = Hash["items" => Array(Array["title"=>"testCreate", "quantity"=>1, "unit_price"=>10.2, "currency_id"=>"ARS"])]
    
preference = $mp.create_preference(preferenceData)

puts preference
```
<a href="http://developers.mercadopago.com/documentacion/recibir-pagos#glossary">Others items to use</a>

### Update an existent Checkout preference:

```ruby
preferenceDataToUpdate = Hash["items" => Array(Array["title"=>"testUpdated", "quantity"=>1, "unit_price"=>2])]

preferenceUpdate = $mp.update_preference("PREFERENCE_ID", preferenceDataToUpdate)

puts preferenceUpdate
```

<a name="payments"></a>
## Using MercadoPago Payment

### Searching:

```ruby    
filters = Array["id"=>null, "site_id"=>null, "external_reference"=>null]

searchResult = $mp.search_payment(filters)

puts searchResult
```
<a href="http://developers.mercadopago.com/documentacion/busqueda-de-pagos-recibidos">More search examples</a>

### Receiving IPN notification:

* Go to **Mercadopago IPN configuration**:
    * Argentina: [https://www.mercadopago.com/mla/herramientas/notificaciones](https://www.mercadopago.com/mla/herramientas/notificaciones)
    * Brasil: [https://www.mercadopago.com/mlb/ferramentas/notificacoes](https://www.mercadopago.com/mlb/ferramentas/notificacoes)
    * México: [https://www.mercadopago.com/mlm/herramientas/notificaciones](https://www.mercadopago.com/mlm/herramientas/notificaciones)
    * Venezuela: [https://www.mercadopago.com/mlv/herramientas/notificaciones](https://www.mercadopago.com/mlv/herramientas/notificaciones)
    * Colombia: [https://www.mercadopago.com/mco/herramientas/notificaciones](https://www.mercadopago.com/mco/herramientas/notificaciones)<br />

```ruby

paymentInfo = $mp.get_payment_info("ID")

puts paymentInfo
```

### Cancel (only for pending payments):

```ruby
result = $mp.cancel_payment("ID");

// Show result
puts result
```

### Refund (only for accredited payments):

```ruby
result = $mp.refund_payment("ID");

// Show result
puts result
```
<a href=http://developers.mercadopago.com/documentacion/devolucion-y-cancelacion>About Cancel & Refund</a>

### Generic resources methods

You can access any other resource from the MercadoPago API using the generic methods:

```ruby
// Get a resource, with optional URL params. Also you can disable authentication for public APIs
$mp.get ("/resource/uri", [params], [authenticate=true])

// Create a resource with "data" and optional URL params.
$mp.post ("/resource/uri", data, [params])

// Update a resource with "data" and optional URL params.
$mp.put ("/resource/uri", data, [params])
```

 For example, if you want to get the Sites list (no params and no authentication):

```ruby
$sites = $mp.get ("/sites", null, false)

puts $sites
```

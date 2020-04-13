# MercadoPago SDK module for Payments integration

* [Install](#install)
* [Basic checkout](#basic-checkout)
* [Customized checkout](#custom-checkout)
* [Generic methods](#generic-methods)

<a name="install"></a>
## Install

```gem install mercadopago-sdk```

<a name="basic-checkout"></a>
## Basic checkout

### Configure your credentials

* Get your **CLIENT_ID** and **CLIENT_SECRET** in the following address:
    * Argentina: [https://www.mercadopago.com/mla/herramientas/aplicaciones](https://www.mercadopago.com/mla/herramientas/aplicaciones)
    * Brazil: [https://www.mercadopago.com/mlb/ferramentas/aplicacoes](https://www.mercadopago.com/mlb/ferramentas/aplicacoes)
    * México: [https://www.mercadopago.com/mlm/herramientas/aplicaciones](https://www.mercadopago.com/mlm/herramientas/aplicaciones)
    * Venezuela: [https://www.mercadopago.com/mlv/herramientas/aplicaciones](https://www.mercadopago.com/mlv/herramientas/aplicaciones)
    * Colombia: [https://www.mercadopago.com/mco/herramientas/aplicaciones](https://www.mercadopago.com/mco/herramientas/aplicaciones)
    * Chile: [https://www.mercadopago.com/mlc/herramientas/aplicaciones](https://www.mercadopago.com/mlc/herramientas/aplicaciones)

```ruby
require 'mercadopago.rb'

$mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')
```

### Preferences

#### Get an existent Checkout preference

```ruby
preference = $mp.preference.get('PREFERENCE_ID')

puts $preferenceResult
```

#### Create a Checkout preference

```ruby

preference_data = {
			"items": [
				{
					"title": "testCreate", 
					"quantity": 1, 
					"unit_price": 10.2, 
					"currency_id": "ARS"
				}
			]
		}
preference = $mp.preference.create(preference_data)

puts preference
```

#### Update an existent Checkout preference

```ruby
preferenceDataToUpdate = Hash["items" => Array(Array["title"=>"testUpdated", "quantity"=>1, "unit_price"=>2])]

preferenceUpdate = $mp.preference.update("PREFERENCE_ID", preferenceDataToUpdate)

puts preferenceUpdate
```

### Payments/Collections

#### Search for payments

```ruby    
filters = Array["id"=>null, "external_reference"=>null]

searchResult = $mp.payment.search(filters)

puts searchResult
```

#### Get payment data

```ruby
paymentInfo = $mp.payment.get("ID")

puts paymentInfo
```

### Cancel (only for pending payments)

```ruby
result = $mp.payment.cancel("ID");

// Show result
puts result
```

### Refund (only for accredited payments)

```ruby
result = $mp.payment.refund("ID");

// Show result
puts result
```

<a name="custom-checkout"></a>
## Customized checkout

### Configure your credentials

* Get your **ACCESS_TOKEN** in the following address:
    * Argentina: [https://www.mercadopago.com/mla/account/credentials](https://www.mercadopago.com/mla/account/credentials)
    * Brazil: [https://www.mercadopago.com/mlb/account/credentials](https://www.mercadopago.com/mlb/account/credentials)
    * Mexico: [https://www.mercadopago.com/mlm/account/credentials](https://www.mercadopago.com/mlm/account/credentials)
    * Venezuela: [https://www.mercadopago.com/mlv/account/credentials](https://www.mercadopago.com/mlv/account/credentials)
    * Colombia: [https://www.mercadopago.com/mco/account/credentials](https://www.mercadopago.com/mco/account/credentials)

```ruby
require 'mercadopago.rb'

$mp = MercadoPago.new('ACCESS_TOKEN')
```

### Create payment

```ruby
$mp.genericcall.post("/v1/payments", payment_data);
```

### Create customer

```ruby
$mp.genericcall.post("/v1/customers", Hash["email" => "email@test.com"]);
```

### Get customer

```ruby
$mp.genericcall.get("/v1/customers/CUSTOMER_ID");
```

* View more Custom checkout related APIs in Developers Site
    * Argentina: [https://www.mercadopago.com.ar/developers](https://www.mercadopago.com.ar/developers)
    * Brazil: [https://www.mercadopago.com.br/developers](https://www.mercadopago.com.br/developers)
    * Mexico: [https://www.mercadopago.com.mx/developers](https://www.mercadopago.com.mx/developers)
    * Venezuela: [https://www.mercadopago.com.ve/developers](https://www.mercadopago.com.ve/developers)
    * Colombia: [https://www.mercadopago.com.co/developers](https://www.mercadopago.com.co/developers)

<a name="generic-methods"></a>
## Generic methods
You can access any other resource from the MercadoPago API using the generic methods:

```ruby
// Get a resource, with optional URL params. Also you can disable authentication for public APIs
$mp.genericcall.get("/resource/uri", [params], [authenticate=true])

// Create a resource with "data" and optional URL params.
$mp.genericcall.post("/resource/uri", data, [params])

// Update a resource with "data" and optional URL params.
$mp.genericcall.put("/resource/uri", data, [params])

// Delete a resource with optional URL params.
$mp.genericcall.delete("/resource/uri", [params])
```

 For example, if you want to get the Sites list (no params and no authentication):

```ruby
$sites = $mp.genericcall.get("/sites", null, false)

puts $sites
```

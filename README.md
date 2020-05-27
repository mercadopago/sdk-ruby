# Mercado Pago SDK for Ruby

[![Gem](https://img.shields.io/gem/v/mercadopago-sdk)](https://rubygems.org/gems/mercadopago-sdk)
[![Gem](https://img.shields.io/gem/dt/mercadopago-sdk)](https://rubygems.org/gems/mercadopago-sdk)
[![APM](https://img.shields.io/apm/l/vim-mode)](https://github.com/mercadopago/sdk-ruby)

This library provides developers with a simple set of bindings to help you integrate Mercado Pago API to a website and start receiving payments.

## 💡 Requirements

The SDK Supports Ruby from version v0 

## 📲 Installation 

First time using Mercado Pago? Create your [Mercado Pago account](https://www.mercadopago.com), if you don’t have one already.

1. Run ```gem install mercadopago-sdk```

2. Copy the access_token in the [credentials](https://www.mercadopago.com/mlb/account/credentials) section of the page and replace YOUR_ACCESS_TOKEN with it.

Thats all, you have Mercado Pago SDK installed.

```ruby
preference = $mp.get_preference('PREFERENCE_ID')

puts $preferenceResult
```

## 🌟 Getting Started
  
  Simple usage looks like:

```ruby
require 'mercadopago.rb'

$mp = MercadoPago.new('YOUR_ACCESS_TOKEN')

preference_data = {
	"items": [
		{
			"title": "testCreate", 
			"quantity": 1, 
			"unit_price": 10.2, 
			"currency_id": "ARS"
		}
preference = $mp.create_preference(preference_data)

puts preference
```

#### Update an existent Checkout preference

```ruby
preferenceDataToUpdate = Hash["items" => Array(Array["title"=>"testUpdated", "quantity"=>1, "unit_price"=>2])]

preferenceUpdate = $mp.update_preference("PREFERENCE_ID", preferenceDataToUpdate)

puts preferenceUpdate
```

### Payments/Collections

#### Search for payments

```ruby    
filters = Array["id"=>null, "external_reference"=>null]

searchResult = $mp.search_payment(filters)

puts searchResult
```

#### Get payment data

```ruby
paymentInfo = $mp.get_payment("ID")

puts paymentInfo
```

### Cancel (only for pending payments)

```ruby
result = $mp.cancel_payment("ID");

// Show result
puts result
```

### Refund (only for accredited payments)

```ruby
result = $mp.refund_payment("ID");

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
$mp.post ("/v1/payments", payment_data);
```

### Create customer

```ruby
$mp.post ("/v1/customers", Hash["email" => "email@test.com"]);
```

Check our official code reference to explore all available functionalities.

```ruby
$mp.get ("/v1/customers/CUSTOMER_ID");
```

If you require technical support, please contact our support team at [developers.mercadopago.com](https://developers.mercadopago.com)

## 🏻 License 

```ruby
// Get a resource, with optional URL params. Also you can disable authentication for public APIs
$mp.get ("/resource/uri", [params], [authenticate=true])

// Create a resource with "data" and optional URL params.
$mp.post ("/resource/uri", data, [params])

// Update a resource with "data" and optional URL params.
$mp.put ("/resource/uri", data, [params])

// Delete a resource with optional URL params.
$mp.delete ("/resource/uri", [params])
```

 For example, if you want to get the Sites list (no params and no authentication):

```ruby
$sites = $mp.get ("/sites", null, false)

puts $sites
```

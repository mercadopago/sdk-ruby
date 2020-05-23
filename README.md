# Mercado Pago SDK for Ruby

![APM](https://img.shields.io/apm/l/vim-mode)

## 📲 Installation 

First time using Mercado Pago? Create your [Mercado Pago account](https://www.mercadopago.com), if you don’t have one already.

1. Run ```gem install mercadopago-sdk```

2. Copy the access_token in the [credentials](https://www.mercadopago.com/mlb/account/credentials) section of the page and replace YOUR_ACCESS_TOKEN with it.

Thats all, you have Mercado Pago SDK installed.


## 🌟 Getting Started
  
  Simple usage looks like:

```ruby
require 'mercadopago.rb'

$mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')

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
preference = $mp.create_preference(preference_data)

puts preference
```

## 📚 Documentation 

See our Documentation with all APIs you can integrate in our DevSite: [Spanish](https://www.mercadopago.com.ar/developers/es/guides/payments/api/introduction/) / [Portuguese](https://www.mercadopago.com.br/developers/pt/guides/payments/api/introduction/)

Check our official code reference to explore all available functionalities.

## ❤️ Support 

If you require technical support, please contact our support team at [developers.mercadopago.com](https://developers.mercadopago.com)

## 🏻 License 

```
MIT license. Copyright (c) 2018 - Mercado Pago / Mercado Libre 
For more information, see the LICENSE file.
```

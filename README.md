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

That's it! Mercado Pago SDK has been successfully installed.

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

## 📚 Documentation 

Visit our Dev Site for further information regarding:
 - Payments APIs: [Spanish](https://www.mercadopago.com.ar/developers/es/guides/payments/api/introduction/) / [Portuguese](https://www.mercadopago.com.br/developers/pt/guides/payments/api/introduction/)
 - Mercado Pago checkout: [Spanish](https://www.mercadopago.com.ar/developers/es/guides/payments/web-payment-checkout/introduction/) / [Portuguese](https://www.mercadopago.com.br/developers/pt/guides/payments/web-payment-checkout/introduction/)
 - Web Tokenize checkout: [Spanish](https://www.mercadopago.com.ar/developers/es/guides/payments/web-tokenize-checkout/introduction/) / [Portuguese](https://www.mercadopago.com.br/developers/pt/guides/payments/web-tokenize-checkout/introduction/)

Check our official code reference to explore all available functionalities.

## ❤️ Support 

If you require technical support, please contact our support team at [developers.mercadopago.com](https://developers.mercadopago.com)

## 🏻 License 

```
MIT license. Copyright (c) 2018 - Mercado Pago / Mercado Libre 
For more information, see the LICENSE file.
```

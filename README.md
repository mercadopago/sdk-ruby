<div align="center">
  <img src="assets/mercado-pago.svg" alt="Mercado Pago" width="120" />
  <h1>Mercado Pago SDK for Ruby</h1>
  <p><strong>The official Mercado Pago SDK for Ruby applications.</strong></p>
  <p>Integrate Mercado Pago APIs into your Ruby application and start receiving payments.</p>
  <p>
    <a href="https://github.com/mercadopago/sdk-ruby/actions/workflows/ci.yml"><img src="assets/badges/ci.svg" alt="CI workflow" /></a>
    <a href="#installation"><img src="assets/badges/package.svg" alt="Ruby package" /></a>
    <img src="assets/badges/runtime.svg" alt="Ruby 3.3 or later" />
    <a href="LICENSE.txt"><img src="assets/badges/license.svg" alt="MIT license" /></a>
  </p>
  <p>
    <a href="#installation">Installation</a> ·
    <a href="#getting-started">Getting started</a> ·
    <a href="#documentation">Documentation</a> ·
    <a href="#contributing">Contributing</a>
  </p>
</div>

---

## 💡 Requirements

Ruby version **3.3 or greater**.

## 📲 Installation

Run ```gem install mercadopago-sdk```

## 🌟 Getting Started

First time using Mercado Pago? Create your [Mercado Pago account](https://www.mercadopago.com).

Copy your `Access Token` in the [credentials panel](https://www.mercadopago.com/developers/panel/app) and replace the text `YOUR_ACCESS_TOKEN` with it.

### Simple usage

To generate a `card token` read the [Checkout API](https://www.mercadopago.com/developers/en/guides/online-payments/checkout-api/introduction) documentation.

```ruby
require 'mercadopago'

sdk = Mercadopago::SDK.new('YOUR_ACCESS_TOKEN')

custom_headers = {
 'x-idempotency-key': '<SOME_UNIQUE_VALUE>'
}

custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

order_data = {
  type: 'online',
  total_amount: '1000.00',
  external_reference: 'ext_ref_1234',
  capture_mode: 'automatic',
  transactions: {
    payments: [
      {
        amount: '1000.00',
        payment_method: {
          id: 'master',
          type: 'credit_card',
          token: '<CARD_TOKEN>',
          installments: 1,
          statement_descriptor: 'Store name'
        }
      }
    ]
  },
  processing_mode: 'automatic',
  description: 'some description',
  payer: {
    email: '<PAYER_EMAIL>',
    first_name: 'John',
    last_name: 'Doe',
    identification: {
      type: 'CPF',
      number: '00000000000'
    }
  }
}

result = sdk.order.create(order_data, custom_request_options)
order = result[:response]

puts order
```

### Per-request configuration

All methods that make API calls accept an optional `RequestOptions` object. This can be used to configure some special options of the request, such as changing credentials or custom headers.

```ruby
require 'mercadopago'

request_options = Mercadopago::RequestOptions.new(access_token: 'YOUR_ACCESS_TOKEN')
# ...

result = sdk.payment.create(payment_data, request_options: request_options)
payment = result[:response]
```

## 📚 Documentation

- [SDK guides](docs/guides/README.md): request options, errors, webhooks, and production guidance.
- [Examples](examples/README.md): integration flows supported by this SDK.
- [API reference](https://www.mercadopago.com/developers/en/reference): request fields and response schemas.

## 🤝 Contributing

All contributions are welcome, ranging from people wanting to triage issues, others wanting to write documentation, to people wanting to contribute code.

Please read and follow our [contribution guidelines](CONTRIBUTING.md). Contributions not following this guidelines will be disregarded. The guidelines are in place to make all of our lives easier and make contribution a consistent process for everyone.

## ❤️ Support

If you require technical support, please contact our support team at [developers.mercadopago.com](https://developers.mercadopago.com).

## 🏻 License

```
MIT license. Copyright (c) 2021 - Mercado Pago / Mercado Libre
For more information, see the LICENSE file.
```

# Mercado Pago Ruby SDK documentation

Use the root README to install the SDK and send a first request. This index connects runnable examples with the operational behavior implemented by the Ruby SDK.

## Start with Orders

Orders is the recommended learning path because it demonstrates the complete payment lifecycle. Begin with [create](../../examples/order/create.rb), inspect the result with [get](../../examples/order/get.rb), and continue with [process](../../examples/order/process.rb), [capture](../../examples/order/capture.rb), [cancel](../../examples/order/cancel.rb), or [refund](../../examples/order/refund.rb).

Before production traffic, read [request options](request-options.md), especially the documented write-retry limitation, and add [typed error handling](error-handling.md). The [Orders-first example catalog](../../examples/README.md#orders-first) also covers Checkout Pro, transactions, PSE, stored credentials, and automatic payments.

## Operational guides

| Question | Guide |
|---|---|
| Which retries are currently automatic? | [Request options](request-options.md) |
| How should failures be classified? | [Error handling](error-handling.md) |
| How should long searches be consumed? | [Automatic pagination](pagination.md) |
| How should signed notifications be processed? | [Webhook validation](webhooks.md) |
| What should be checked first during an incident? | [Troubleshooting](troubleshooting.md) |

Endpoint fields and response schemas belong to the [Mercado Pago API reference](https://www.mercadopago.com/developers/en/reference).

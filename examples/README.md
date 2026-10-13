# Ruby examples

These programs demonstrate integration flows implemented by the Ruby SDK. Start with Orders, then choose another API only when the payment product requires it.

## Orders first

Orders is the most complete learning path in this repository: it covers creation, retrieval, processing, capture, cancellation, refunds, and transaction management.

| Stage | Goal | Example |
|---|---|---|
| 1. Create | Submit a basic order | [`create.rb`](order/create.rb) |
| 2. Inspect | Retrieve the server-side result | [`get.rb`](order/get.rb) |
| 3. Advance | Process or capture an order | [`process.rb`](order/process.rb) · [`capture.rb`](order/capture.rb) |
| 4. Reverse | Cancel or refund an order | [`cancel.rb`](order/cancel.rb) · [`refund.rb`](order/refund.rb) |
| 5. Manage transactions | Create, update, or delete a transaction | [`transaction/create.rb`](order/transaction/create.rb) · [`transaction/update.rb`](order/transaction/update.rb) · [`transaction/delete.rb`](order/transaction/delete.rb) |
| 6. Add a payment flow | Use Checkout Pro, PSE, or automatic payments | [`create_checkout_pro.rb`](order/create_checkout_pro.rb) · [`create_pse.rb`](order/create_pse.rb) · [`create_automatic_payment.rb`](order/create_automatic_payment.rb) |
| 7. Use stored credentials | Create a credential-on-file payment | [`automatic_payment_credential_on_file.rb`](payment/automatic_payment_credential_on_file.rb) |

The current SDK automatically retries GET paths, not Orders writes. Before production use, own the write retry/reconciliation policy and persist the idempotency key. See [request options](../docs/guides/request-options.md) and [error handling](../docs/guides/error-handling.md).

## Other supported examples

| Goal | API | Examples |
|---|---|---|
| Create a hosted checkout | Preferences API | [`preference/`](preference/) |
| Connect a seller account | OAuth API | [`oauth/`](oauth/) |
| Create a Point payment intent | Point API | [`point/`](point/) |
| Search chargebacks | Chargebacks API | [`chargeback/`](chargeback/) |

Run examples with test credentials and test data, replace every placeholder, and confirm fields in the [API reference](https://www.mercadopago.com/developers/en/reference). Never commit credentials or use production card data in examples.

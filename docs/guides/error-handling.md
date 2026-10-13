# Handle API and connection errors

Catch the most specific SDK error on which the application can act:

```ruby
begin
  result = sdk.order.create(data, request_options: options)
rescue Mercadopago::MPRateLimitError => error
  warn "Retry after: #{error.retry_after}"
rescue Mercadopago::MPConnectionError
  warn 'No API response was received'
rescue Mercadopago::MercadoPagoError => error
  warn "Status: #{error.status_code}; code: #{error.error}"
end
```

Choose recovery by error category:

| Category | Application decision |
|---|---|
| Authentication or forbidden | Stop; correct credentials or permissions. |
| Bad request or validation | Correct the request; an identical retry will fail. |
| Idempotency | Preserve the key and reconcile the original operation. |
| Rate limit | Respect `retry_after` and reduce concurrency. |
| Dependency, locked resource, or server | Retry only within a bounded policy. |
| `MPConnectionError` | A write may have completed; reconcile before retrying. |

`Mercadopago::MercadoPagoError` is the common API error and exposes `status_code`, `error`, and `causes`. Avoid rescuing `StandardError` unless the boundary adds context and then reraises or converts the failure predictably.

Log the SDK error class, status, operation, request ID when available, and your own correlation ID. Never log access tokens, card data, full bodies, or complete API responses.

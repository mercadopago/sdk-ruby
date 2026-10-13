# Request options, retries, and idempotency

Use `RequestOptions` for shared defaults or to customize one call:

```ruby
options = Mercadopago::RequestOptions.new(
  connection_timeout: 10.0,
  max_retries: 3,
  jitter: true,
  custom_headers: { 'X-Idempotency-Key' => 'order-2026-0001' }
)

sdk.order.create(data, request_options: options)
```

The retry policy defaults to three attempts, a 60-second timeout, and HTTP `429`, `500`, `502`, `503`, and `504`, with bounded exponential backoff, optional jitter, and `on_retry` telemetry.

Important: in the current SDK implementation, automatic retry execution is wired to GET requests used by reads and searches. Do not assume that POST, PUT, or DELETE writes are automatically retried. If your application retries a write, own that policy explicitly and use one stable idempotency key.

Generate the key when the business operation begins, persist it with your internal record, and reuse it only for attempts of the same payload. After a timeout or connection error, reconcile by resource ID or external reference before repeating the write: a missing response does not prove the operation failed. A new logical operation requires a new key.

Keep application, job, and SDK retry layers bounded so their combined duration does not exceed the caller's deadline.

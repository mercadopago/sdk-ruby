# Validate and process webhooks

Validate signed notifications before trusting their identifiers:

```ruby
begin
  Mercadopago::Webhook::Validator.validate(
    request.headers['x-signature'],
    request.headers['x-request-id'],
    request.params['data.id'],
    ENV.fetch('MP_WEBHOOK_SECRET'),
    tolerance_seconds: 300
  )
rescue Mercadopago::Webhook::InvalidWebhookSignatureError
  halt 401
end
```

Pass `x-signature`, `x-request-id`, and `data.id` exactly as received. Trimming, decoding, or normalizing them can change the signed manifest. QR Code notifications are not signed and must not use this validator.

A production endpoint should validate the signature and timestamp, deduplicate by notification or resource identifier, enqueue the identifier, and acknowledge promptly. The worker then fetches the current resource from Mercado Pago and applies state transitions idempotently because delivery can repeat or arrive out of order.

Treat the notification as a signal rather than the authoritative resource state. Keep server clocks synchronized and set a tolerance that accepts ordinary network latency without allowing old replays. Log a sanitized validation outcome, but never the secret or complete signature.

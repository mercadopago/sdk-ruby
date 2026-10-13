# Troubleshooting

## A write was not retried

Automatic retry execution currently applies to GET paths. POST, PUT, and DELETE need an application-owned retry/reconciliation policy and a stable idempotency key.

## A write raised `MPConnectionError`

The result is unknown, not necessarily failed. Query by resource ID or external reference before retrying the same payload with the same idempotency key.

## An auto-paging job fails midway

The iterator requests pages lazily, so a later request can fail after earlier items were handled. Make processing idempotent and persist a business checkpoint when restartability matters.

## Webhook validation fails

Verify unchanged `x-request-id` and `data.id` values, server clock synchronization, and the endpoint secret. Do not validate unsigned QR Code notifications.

## Escalating an issue

Include SDK and Ruby versions, operation, HTTP status, request ID, sanitized error class/message, and a minimal reproduction. Open a repository issue without credentials, card data, webhook secrets, or exploit details.

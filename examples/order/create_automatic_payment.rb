require_relative '../../lib/mercadopago'

# Mercado Pago Create Order — Automatic Payments (recurring charges).
#
# Demonstrates the two-step Automatic Payments flow:
#   1. First payment  — CVV-validated charge that registers the card credential.
#   2. Recurring charge — subsequent MIT charge without CVV, referencing step 1.
#
# Prerequisites:
#   - A customer created via POST /v1/customers             → customer_id
#   - A payment profile created via POST /v1/customers/{id}/payment-profiles → payment_profile_id

sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

# ── Step 1: First payment ─────────────────────────────────────────────────────
# Registers the card credential with first_payment: true.
# No prev_transaction_ref is needed on the first charge.
def create_first_payment(sdk, customer_id:, payment_profile_id:, payer_email:, card_token:)
  request = {
    type: 'online',
    processing_mode: 'automatic',
    total_amount: '100.00',
    external_reference: 'subscription-001-payment-1',
    payer: {
      email: payer_email,
      customer_id: customer_id
    },
    transactions: {
      payments: [
        {
          amount: '100.00',
          payment_method: {
            id: 'master',
            type: 'credit_card',
            token: card_token,
            installments: 1
          },
          automatic_payments: {
            payment_profile_id: payment_profile_id
          },
          stored_credential: {
            payment_initiator: 'customer',
            reason: 'recurring',
            first_payment: true
          }
        }
      ]
    }
  }

  custom_headers = { 'X-Idempotency-Key': '<IDEMPOTENCY_KEY_FIRST>' }
  request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  sdk.order.create(request, request_options: request_options)
rescue StandardError => e
  puts e.message
  nil
end

# ── Step 2: Recurring charge ──────────────────────────────────────────────────
# Subsequent MIT charge — no card token needed, uses the payment profile.
# prev_transaction_ref links this charge to the original authorization.
def create_recurring_charge(sdk,
                             customer_id:,
                             payment_profile_id:,
                             payer_email:,
                             previous_transaction_reference:,
                             sequence_number:)
  request = {
    type: 'online',
    processing_mode: 'automatic_async',
    total_amount: '100.00',
    external_reference: "subscription-001-payment-#{sequence_number}",
    payer: {
      email: payer_email,
      customer_id: customer_id
    },
    transactions: {
      payments: [
        {
          amount: '100.00',
          automatic_payments: {
            payment_profile_id: payment_profile_id,
            retries: 3,
            schedule_date: '2026-09-01T00:00:00.000-04:00',
            due_date: '2026-09-05T00:00:00.000-04:00'
          },
          stored_credential: {
            payment_initiator: 'merchant',
            reason: 'recurring',
            first_payment: false,
            previous_transaction_reference: previous_transaction_reference
          },
          subscription_data: {
            invoice_id: "INV-00#{sequence_number}",
            billing_date: '2026-08-01',
            subscription_sequence: {
              number: sequence_number,
              total: 12
            },
            invoice_period: {
              type: 'monthly',
              period: 1
            }
          }
        }
      ]
    }
  }

  custom_headers = { 'X-Idempotency-Key': "<IDEMPOTENCY_KEY_RECURRING_#{sequence_number}>" }
  request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  sdk.order.create(request, request_options: request_options)
rescue StandardError => e
  puts e.message
  nil
end

# ── Run the flow ──────────────────────────────────────────────────────────────
customer_id       = '<CUSTOMER_ID>'
payment_profile_id = '<PAYMENT_PROFILE_ID>'
payer_email       = '<PAYER_EMAIL>'
card_token        = '<CARD_TOKEN>'

# First payment
first_result = create_first_payment(
  sdk,
  customer_id: customer_id,
  payment_profile_id: payment_profile_id,
  payer_email: payer_email,
  card_token: card_token
)

if first_result
  first_order = first_result[:response]
  puts "First payment order ID: #{first_order['id']}"
  puts "Status: #{first_order['status']}"

  # Save the payment ID for the next recurring charge
  first_payment_id = first_order.dig('transactions', 'payments', 0, 'id')
  puts "First payment ID (save for next charge): #{first_payment_id}"

  # Recurring charge
  if first_payment_id
    recurring_result = create_recurring_charge(
      sdk,
      customer_id: customer_id,
      payment_profile_id: payment_profile_id,
      payer_email: payer_email,
      previous_transaction_reference: first_payment_id,
      sequence_number: 2
    )

    if recurring_result
      recurring_order = recurring_result[:response]
      puts "\nRecurring charge order ID: #{recurring_order['id']}"
      puts "Status: #{recurring_order['status']}"
      puts "Status detail: #{recurring_order['status_detail']}"
    end
  end
end

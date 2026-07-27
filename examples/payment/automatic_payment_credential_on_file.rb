# Example: Automatic Payments with CREDENTIAL_ON_FILE (COF).
#
# CREDENTIAL_ON_FILE replaces the deprecated SUBSCRIPTIONS type for recurring
# and unscheduled automatic payments. It covers three main scenarios:
#
#   1. CIT – Customer-Initiated Transaction (enrollment / first charge):
#      The customer actively authorizes the initial payment and consents to
#      storing their credentials for future merchant-initiated charges.
#
#   2. MIT – Merchant-Initiated Transaction (recurring charge):
#      Subsequent charges triggered by the merchant without customer
#      interaction (e.g. monthly subscription billing).
#
#   3. UCOF-CIT – Unscheduled COF Customer-Initiated Transaction:
#      A one-off purchase where the customer uses previously stored
#      credentials, but the amount / date was not pre-agreed.
#
# Reference: https://www.mercadopago.com/developers/en/reference

require_relative '../../lib/mercadopago'

sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

# ---------------------------------------------------------------------------
# 1. CIT — Customer-Initiated Transaction (enrollment)
#
# The customer completes the first payment and grants permission to store
# their card credentials for future recurring charges.
# ---------------------------------------------------------------------------
def create_cit_payment(sdk)
  request = {
    transaction_amount: 100.00,
    token: '<CARD_TOKEN>',
    description: 'Monthly subscription — enrollment',
    installments: 1,
    payment_method_id: '<PAYMENT_METHOD_ID>',
    payer: {
      email: '<PAYER_EMAIL>',
      identification: {
        type: '<ID_TYPE>',
        number: '<ID_NUMBER>'
      }
    },
    # CREDENTIAL_ON_FILE block for the enrollment (first) transaction.
    point_of_interaction: {
      linked_to: 'subscription',
      transaction_data: {
        # type: "CREDENTIAL_ON_FILE" — new credential-on-file payment type.
        type: 'CREDENTIAL_ON_FILE',
        # sub_type: "recurring" — charge is part of a recurring series.
        sub_type: 'recurring',
        # storage: "store" — instructs the processor to persist the credentials.
        storage: 'store',
        # transaction_initiator: "customer" — the customer triggered this charge.
        transaction_initiator: 'customer',
        # first_transaction: true — marks this as the enrollment / anchor payment.
        first_transaction: true
      }
    }
  }

  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  result = sdk.payment.create(request, request_options: custom_request_options)
  payment = result[:response]
  puts "CIT payment created. ID: #{payment['id']}, status: #{payment['status']}"
  payment['id'] # return payment ID to use as reference in subsequent MITs
rescue MercadoPago::MPApiException => e
  puts "Status code: #{e.api_response.status_code}"
  puts "Content: #{e.api_response.content}"
rescue StandardError => e
  puts e.message
end

# ---------------------------------------------------------------------------
# 2. MIT — Merchant-Initiated Transaction (recurring monthly charge)
#
# The merchant charges the customer without customer interaction, using the
# credentials stored during the CIT enrollment. The CIT payment ID is
# provided as a reference to the original agreement.
# ---------------------------------------------------------------------------
def create_mit_payment(sdk, cit_payment_id)
  request = {
    transaction_amount: 100.00,
    token: '<CARD_TOKEN>',
    description: 'Monthly subscription — recurring charge',
    installments: 1,
    payment_method_id: '<PAYMENT_METHOD_ID>',
    payer: {
      email: '<PAYER_EMAIL>',
      identification: {
        type: '<ID_TYPE>',
        number: '<ID_NUMBER>'
      }
    },
    # CREDENTIAL_ON_FILE block for merchant-initiated recurring charges.
    point_of_interaction: {
      linked_to: 'subscription',
      transaction_data: {
        # type: "CREDENTIAL_ON_FILE" — same type as the enrollment.
        type: 'CREDENTIAL_ON_FILE',
        # sub_type: "recurring" — charge belongs to a recurring series.
        sub_type: 'recurring',
        # storage: "stored" — credentials were already stored in a prior CIT.
        storage: 'stored',
        # transaction_initiator: "merchant" — the merchant triggered this charge.
        transaction_initiator: 'merchant',
        # first_transaction: false — not the enrollment; uses stored credentials.
        first_transaction: false,
        # reference.id — ID of the CIT payment that anchors this agreement.
        reference: {
          id: cit_payment_id.to_s
        }
      }
    }
  }

  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  result = sdk.payment.create(request, request_options: custom_request_options)
  payment = result[:response]
  puts "MIT payment created. ID: #{payment['id']}, status: #{payment['status']}"
rescue MercadoPago::MPApiException => e
  puts "Status code: #{e.api_response.status_code}"
  puts "Content: #{e.api_response.content}"
rescue StandardError => e
  puts e.message
end

# ---------------------------------------------------------------------------
# 3. UCOF-CIT — Unscheduled COF Customer-Initiated Transaction
#
# The customer actively initiates a one-off purchase using previously stored
# credentials. The amount and date were not pre-agreed (unscheduled), but the
# customer is present and initiates the transaction themselves.
# ---------------------------------------------------------------------------
def create_ucof_cit_payment(sdk)
  request = {
    transaction_amount: 250.00,
    token: '<CARD_TOKEN>',
    description: 'One-off purchase with stored credentials',
    installments: 1,
    payment_method_id: '<PAYMENT_METHOD_ID>',
    payer: {
      email: '<PAYER_EMAIL>',
      identification: {
        type: '<ID_TYPE>',
        number: '<ID_NUMBER>'
      }
    },
    # CREDENTIAL_ON_FILE block for an unscheduled customer-initiated purchase.
    point_of_interaction: {
      linked_to: 'subscription',
      transaction_data: {
        # type: "CREDENTIAL_ON_FILE" — credential-on-file payment type.
        type: 'CREDENTIAL_ON_FILE',
        # sub_type: "unscheduled" — amount/date not pre-agreed; ad-hoc purchase.
        sub_type: 'unscheduled',
        # storage: "stored" — credentials already stored from a prior enrollment.
        storage: 'stored',
        # transaction_initiator: "customer" — the customer triggered this charge.
        transaction_initiator: 'customer',
        # first_transaction: false — uses previously stored credentials.
        first_transaction: false
      }
    }
  }

  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  result = sdk.payment.create(request, request_options: custom_request_options)
  payment = result[:response]
  puts "UCOF-CIT payment created. ID: #{payment['id']}, status: #{payment['status']}"
rescue MercadoPago::MPApiException => e
  puts "Status code: #{e.api_response.status_code}"
  puts "Content: #{e.api_response.content}"
rescue StandardError => e
  puts e.message
end

# Run all three scenarios sequentially.
# In production, CIT runs once at enrollment; MIT runs on each billing cycle.
cit_payment_id = create_cit_payment(sdk)
create_mit_payment(sdk, cit_payment_id) if cit_payment_id
create_ucof_cit_payment(sdk)

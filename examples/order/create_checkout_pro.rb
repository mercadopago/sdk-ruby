require_relative '../../lib/mercadopago'


sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

def create_checkout_pro_order(sdk)
  request = {
    total_amount: '500.00',
    external_reference: 'ext_ref_checkout_pro',
    capture_mode: 'automatic',
    marketplace_fee: '5.00',
    description: 'Travel package SAO-RIO with insurance',
    expiration_time: 'P1D',
    payer: {
      email: '<PAYER_EMAIL>',
      first_name: 'John',
      last_name: 'Smith',
      phone: {
        area_code: '11',
        number: '999998888'
      },
      identification: {
        type: 'CPF',
        number: '12345678909'
      }
    },
    shipment: {
      mode: 'custom',
      local_pickup: false,
      cost: '15.00',
      free_shipping: false,
      address: {
        zip_code: '01310-100',
        street_name: 'Av. Paulista',
        street_number: '1000',
        neighborhood: 'Bela Vista',
        city: 'Sao Paulo'
      }
    },
    config: {
      statement_descriptor: 'MYSTORE',
      default_payment_due_date: 'P1D',
      online: {
        available_from: '2026-01-01T00:00:00Z',
        allowed_user_type: 'account_only',
        success_url: 'https://example.com/success',
        failure_url: 'https://example.com/failure',
        pending_url: 'https://example.com/pending',
        auto_return: 'approved',
        tracks: [
          {
            type: 'google_ad',
            values: {
              conversion_id: '21312312312123',
              conversion_label: 'TEST'
            }
          },
          {
            type: 'facebook_ad',
            values: {
              pixel_id: '21312312312123'
            }
          }
        ]
      },
      payment_method: {
        max_installments: 12,
        not_allowed_ids: ['amex'],
        not_allowed_types: ['ticket'],
        installments: {
          interest_free: {
            type: 'range',
            values: [2, 6]
          }
        }
      }
    },
    items: [
      {
        external_code: 'ITEM-001',
        title: 'Flight SAO-RIO',
        description: 'Round trip, economy class',
        category_id: 'travels',
        picture_url: 'https://example.com/img.jpg',
        quantity: 1,
        unit_price: '450.00',
        type: 'travel',
        event_date: '2027-01-15T00:00:00.000-03:00'
      },
      {
        external_code: 'ITEM-002',
        title: 'Travel insurance',
        description: 'Basic coverage during trip',
        category_id: 'travels',
        picture_url: 'https://example.com/insurance.jpg',
        quantity: 1,
        unit_price: '50.00',
        type: 'travel',
        event_date: '2027-01-15T00:00:00.000-03:00'
      }
    ]
  }

  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  result = sdk.order.create_checkout_pro(request, request_options: custom_request_options)
  order = result[:response]

  puts order
  puts "Redirect buyer to: #{order['checkout_url']}"

rescue StandardError => e
  puts e.message
end

create_checkout_pro_order(sdk)

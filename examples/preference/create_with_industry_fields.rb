# Example: Create a Checkout Preference with industry-specific fields.
# Demonstrates payer authentication info, item category descriptors,
# passenger/route details, and shipment address enrichment.

require_relative '../../lib/mercadopago'

sdk = Mercadopago::SDK.new('<ACCESS_TOKEN>')

def create_preference_with_industry_fields(sdk)
  request = {
    payer: {
      name: 'John',
      surname: 'Smith',
      email: '<PAYER_EMAIL>',
      phone: {
        area_code: '11',
        number: '999998888'
      },
      identification: {
        type: 'CPF',
        number: '12345678909'
      },
      address: {
        zip_code: '01310-100',
        street_name: 'Av. Paulista',
        street_number: 1000
      },
      date_created: '2024-01-01T00:00:00Z',
      authentication_type: 'Gmail',
      is_prime_user: false,
      is_first_purchase_online: false,
      last_purchase: '2024-01-01T00:00:00Z',
      registration_date: '2023-01-01T00:00:00Z'
    },
    items: [
      {
        id: 'ITEM-001',
        title: 'Flight SAO-RIO',
        description: 'Round trip, economy class',
        category_id: 'travels',
        picture_url: 'https://example.com/img.jpg',
        quantity: 1,
        currency_id: 'BRL',
        unit_price: 450.00,
        warranty: false,
        event_date: '2027-01-15T00:00:00.000-03:00',
        category_descriptor: {
          passenger: {
            first_name: 'John',
            last_name: 'Smith',
            identification: {
              type: 'CPF',
              number: '12345678909'
            }
          },
          route: {
            departure: 'SAO',
            destination: 'RIO',
            departure_date_time: '2027-01-15T08:00:00.000-03:00',
            arrival_date_time: '2027-01-15T09:30:00.000-03:00',
            company: 'LATAM'
          }
        }
      },
      {
        id: 'ITEM-002',
        title: 'Travel insurance',
        description: 'Basic coverage during trip',
        category_id: 'travels',
        picture_url: 'https://example.com/insurance.jpg',
        quantity: 1,
        currency_id: 'BRL',
        unit_price: 50.00,
        warranty: true,
        event_date: '2027-01-15T00:00:00.000-03:00',
        category_descriptor: {
          passenger: {
            first_name: 'John',
            last_name: 'Smith',
            identification: {
              type: 'CPF',
              number: '12345678909'
            }
          },
          route: {
            departure: 'SAO',
            destination: 'RIO',
            departure_date_time: '2027-01-15T08:00:00.000-03:00',
            arrival_date_time: '2027-01-15T09:30:00.000-03:00',
            company: 'LATAM'
          }
        }
      }
    ],
    shipments: {
      mode: 'custom',
      local_pickup: false,
      express_shipment: false,
      cost: 15.0,
      free_shipping: false,
      receiver_address: {
        zip_code: '01310-100',
        street_name: 'Av. Paulista',
        street_number: 1000,
        state_name: 'Sao Paulo',
        city_name: 'Sao Paulo',
        floor: '2',
        apartment: 'A'
      }
    },
    back_urls: {
      success: 'https://example.com/success',
      failure: 'https://example.com/failure',
      pending: 'https://example.com/pending'
    },
    auto_return: 'approved',
    external_reference: 'MP0001',
    notification_url: 'https://example.com/notifications',
    statement_descriptor: 'MYSTORE'
  }

  custom_headers = {
    'X-Idempotency-Key': '<SOME_UNIQUE_VALUE>'
  }
  custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)

  result = sdk.preference.create(request, request_options: custom_request_options)
  preference = result[:response]

  puts "Preference id: #{preference['id']}"
  puts "Init point: #{preference['init_point']}"

rescue StandardError => e
  puts e.message
end

create_preference_with_industry_fields(sdk)

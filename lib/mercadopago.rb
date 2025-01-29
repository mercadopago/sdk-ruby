# typed: strict
# frozen_string_literal: true

require_relative './mercadopago/http/http_client'

require_relative './mercadopago/core/mp_base'

require_relative './mercadopago/config/config'
require_relative './mercadopago/config/request_options'

require_relative './mercadopago/resources/customer'
require_relative './mercadopago/resources/card'
require_relative './mercadopago/resources/user'
require_relative './mercadopago/resources/identification_type'
require_relative './mercadopago/resources/preference'
require_relative './mercadopago/resources/payment'
require_relative './mercadopago/resources/card_token'
require_relative './mercadopago/resources/refund'
require_relative './mercadopago/resources/merchant_order'
require_relative './mercadopago/resources/payment_methods'
require_relative './mercadopago/resources/advanced_payment'
require_relative './mercadopago/resources/disbursement_refund'
require_relative './mercadopago/resources/preapproval'
require_relative './mercadopago/resources/preapproval_plan'
require_relative './mercadopago/resources/order'
require_relative './mercadopago/resources/order_transaction'

require_relative './mercadopago/sdk'

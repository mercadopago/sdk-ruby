# typed: strict
# frozen_string_literal: true

# Top-level namespace for the MercadoPago Ruby SDK.
#
# Provides a complete Ruby client for the MercadoPago REST API, enabling
# payment processing, customer management, subscriptions, orders, and
# related financial operations.
#
# All interaction starts through {Mercadopago::SDK}, which acts as the
# entry point and factory for every API resource.
#
# @example Basic usage
#   sdk = Mercadopago::SDK.new('YOUR_ACCESS_TOKEN')
#   payment = sdk.payment.create({ transaction_amount: 100, ... })
#
# @see https://www.mercadopago.com/developers MercadoPago Developer Docs
module Mercadopago; end

# --- HTTP layer ---
require_relative './mercadopago/http/http_client'

# --- Core ---
require_relative './mercadopago/core/mp_base'

# --- Configuration ---
require_relative './mercadopago/config/config'
require_relative './mercadopago/config/request_options'

# --- API Resources ---
require_relative './mercadopago/resources/chargeback'
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
require_relative './mercadopago/resources/invoice'
require_relative './mercadopago/resources/oauth'
require_relative './mercadopago/resources/order'
require_relative './mercadopago/resources/order/request'
require_relative './mercadopago/resources/order_transaction'
require_relative './mercadopago/resources/point'

# --- Entry point ---
require_relative './mercadopago/sdk'

# typed: true
# frozen_string_literal: true

module Mercadopago
  class Order < MPBase
    # Typed, optional Request model for building an Orders API create body.
    #
    # This module is an *optional* alternative to passing a plain +Hash+ to
    # {Order#create}. Each class mirrors a section of the Orders API request
    # body (see the canonical field reference derived from the Go/.NET SDKs)
    # and exposes {#to_hash}, which produces the exact snake_case +Hash+ the
    # API expects.
    #
    # Field names, types, and nesting come strictly from the canonical Go
    # (`sdk-go/pkg/order/request.go`) definition, cross-validated against
    # .NET. Nothing is invented.
    #
    # == Serialization contract (DD-3)
    #
    # {#to_hash} omits +nil+ fields (via +.compact+) so the resulting JSON is
    # identical to what an integrator would build by hand with a Hash. Nested
    # Request objects and arrays of them are converted recursively.
    #
    # == Usage
    #
    #   req = Mercadopago::Order::Request::CreateRequest.new(
    #     type: 'online',
    #     total_amount: '1000.00',
    #     payer: Mercadopago::Order::Request::PayerRequest.new(
    #       email: 'buyer@example.com'
    #     )
    #   )
    #   sdk.order.create(req)   # accepts the typed object OR a plain Hash
    #
    # Every class is built with +Data.define+ (Ruby 3.2+; the gem requires
    # >= 3.3.0). All members default to +nil+ so only the fields you set are
    # sent.
    module Request
      # Recursively converts a value to its plain-Hash / primitive form.
      #
      # - A Request object (anything responding to +to_hash+ that is not a
      #   Hash) is converted via its own +to_hash+.
      # - An Array is mapped element-wise.
      # - Any other value (String, Integer, Boolean, Hash, nil) passes through.
      #
      # @param value [Object] value to normalize
      # @return [Object] plain-Hash / primitive representation
      def self.deep_to_hash(value)
        if value.is_a?(Array)
          value.map { |element| deep_to_hash(element) }
        elsif !value.is_a?(Hash) && value.respond_to?(:to_hash)
          value.to_hash
        else
          value
        end
      end

      # Builds a snake_case Hash from a +Data+ member Hash, omitting nils and
      # recursively converting nested Request objects / arrays (DD-3).
      #
      # @param members [Hash{Symbol => Object}] +to_h+ of a Data instance
      # @return [Hash{Symbol => Object}] compacted, recursively-converted Hash
      def self.build_hash(members)
        members.each_with_object({}) do |(key, value), acc|
          next if value.nil?

          acc[key] = deep_to_hash(value)
        end
      end

      # Mixin providing a canonical {#to_hash} for every Request +Data+ class.
      module HashConversion
        # @return [Hash{Symbol => Object}] snake_case body fragment with nils omitted
        def to_hash
          Request.build_hash(to_h)
        end
      end

      # == A. Order root ==
      # Root of the Orders API create request body.
      CreateRequest = Data.define(
        :type,
        :external_reference,
        :total_amount,
        :currency,
        :capture_mode,
        :processing_mode,
        :description,
        :marketplace,
        :marketplace_fee,
        :expiration_time,
        :checkout_available_at,
        :transactions,
        :payer,
        :items,
        :config,
        :shipment,
        :additional_info,
        :integration_data
      ) do
        include HashConversion

        def initialize(
          type: nil, external_reference: nil, total_amount: nil, currency: nil,
          capture_mode: nil, processing_mode: nil, description: nil, marketplace: nil,
          marketplace_fee: nil, expiration_time: nil, checkout_available_at: nil,
          transactions: nil, payer: nil, items: nil, config: nil, shipment: nil,
          additional_info: nil, integration_data: nil
        )
          super
        end
      end

      # == B. transactions ==
      TransactionRequest = Data.define(:payments) do
        include HashConversion

        def initialize(payments: nil)
          super
        end
      end

      # == B. payments[] ==
      PaymentRequest = Data.define(
        :amount,
        :expiration_time,
        :date_of_expiration,
        :payment_method,
        :automatic_payments,
        :stored_credential,
        :subscription_data
      ) do
        include HashConversion

        def initialize(
          amount: nil, expiration_time: nil, date_of_expiration: nil,
          payment_method: nil, automatic_payments: nil, stored_credential: nil,
          subscription_data: nil
        )
          super
        end
      end

      # == C. payment_method ==
      PaymentMethodRequest = Data.define(
        :id,
        :type,
        :token,
        :statement_descriptor,
        :installments,
        :financial_institution
      ) do
        include HashConversion

        def initialize(
          id: nil, type: nil, token: nil, statement_descriptor: nil,
          installments: nil, financial_institution: nil
        )
          super
        end
      end

      # == D. automatic_payments ==
      AutomaticPaymentsRequest = Data.define(
        :payment_profile_id,
        :schedule_date,
        :due_date,
        :retries
      ) do
        include HashConversion

        def initialize(payment_profile_id: nil, schedule_date: nil, due_date: nil, retries: nil)
          super
        end
      end

      # == D2. stored_credential ==
      StoredCredentialRequest = Data.define(
        :payment_initiator,
        :reason,
        :store_payment_method,
        :first_payment,
        :prev_transaction_ref
      ) do
        include HashConversion

        def initialize(
          payment_initiator: nil, reason: nil, store_payment_method: nil,
          first_payment: nil, prev_transaction_ref: nil
        )
          super
        end
      end

      # == D3. subscription_data ==
      SubscriptionDataRequest = Data.define(
        :invoice_id,
        :billing_date,
        :subscription_sequence,
        :invoice_period
      ) do
        include HashConversion

        def initialize(invoice_id: nil, billing_date: nil, subscription_sequence: nil, invoice_period: nil)
          super
        end
      end

      # == D3. subscription_data.subscription_sequence ==
      SubscriptionSequenceRequest = Data.define(:number, :total) do
        include HashConversion

        def initialize(number: nil, total: nil)
          super
        end
      end

      # == D3. subscription_data.invoice_period ==
      InvoicePeriodRequest = Data.define(:type, :period) do
        include HashConversion

        def initialize(type: nil, period: nil)
          super
        end
      end

      # == E. payer ==
      PayerRequest = Data.define(
        :email,
        :first_name,
        :last_name,
        :customer_id,
        :entity_type,
        :identification,
        :phone,
        :address
      ) do
        include HashConversion

        def initialize(
          email: nil, first_name: nil, last_name: nil, customer_id: nil,
          entity_type: nil, identification: nil, phone: nil, address: nil
        )
          super
        end
      end

      # == E. payer.identification ==
      IdentificationRequest = Data.define(:type, :number) do
        include HashConversion

        def initialize(type: nil, number: nil)
          super
        end
      end

      # == E. payer.phone ==
      PhoneRequest = Data.define(:area_code, :number) do
        include HashConversion

        def initialize(area_code: nil, number: nil)
          super
        end
      end

      # == E/G. address ==
      # Covers both payer.address and shipment.address. The API tolerates the
      # union of both field sets; unset fields are omitted.
      AddressRequest = Data.define(
        :zip_code,
        :street_name,
        :street_number,
        :neighborhood,
        :city,
        :state,
        :complement,
        :country,
        :floor,
        :apartment
      ) do
        include HashConversion

        def initialize(
          zip_code: nil, street_name: nil, street_number: nil, neighborhood: nil,
          city: nil, state: nil, complement: nil, country: nil, floor: nil, apartment: nil
        )
          super
        end
      end

      # == F. items[] ==
      ItemRequest = Data.define(
        :title,
        :type,
        :warranty,
        :event_date,
        :unit_price,
        :external_code,
        :category_id,
        :description,
        :picture_url,
        :quantity
      ) do
        include HashConversion

        def initialize(
          title: nil, type: nil, warranty: nil, event_date: nil, unit_price: nil,
          external_code: nil, category_id: nil, description: nil, picture_url: nil,
          quantity: nil
        )
          super
        end
      end

      # == G. shipment ==
      ShipmentRequest = Data.define(
        :mode,
        :local_pickup,
        :cost,
        :free_shipping,
        :free_methods,
        :address
      ) do
        include HashConversion

        def initialize(
          mode: nil, local_pickup: nil, cost: nil, free_shipping: nil,
          free_methods: nil, address: nil
        )
          super
        end
      end

      # == integration_data (root) ==
      IntegrationDataRequest = Data.define(
        :integrator_id,
        :platform_id,
        :corporation_id,
        :sponsor
      ) do
        include HashConversion

        def initialize(integrator_id: nil, platform_id: nil, corporation_id: nil, sponsor: nil)
          super
        end
      end

      # == integration_data.sponsor ==
      SponsorRequest = Data.define(:id) do
        include HashConversion

        def initialize(id: nil)
          super
        end
      end

      # == H. config ==
      # Holds the online sub-object where +transaction_security+ lives (under
      # +config.online+, NOT root). +payment_method+ and +online+ are kept as
      # free-form Hashes / typed objects; both convert recursively.
      ConfigRequest = Data.define(
        :notification_url,
        :statement_descriptor,
        :default_payment_due_date,
        :payment_method,
        :online
      ) do
        include HashConversion

        def initialize(
          notification_url: nil, statement_descriptor: nil,
          default_payment_due_date: nil, payment_method: nil, online: nil
        )
          super
        end
      end

      # == H. config.online.transaction_security ==
      TransactionSecurityRequest = Data.define(:validation, :liability_shift) do
        include HashConversion

        def initialize(validation: nil, liability_shift: nil)
          super
        end
      end
    end
  end
end

# typed: true
# frozen_string_literal: true

require 'openssl'

module Mercadopago
  # Webhook signature validation utilities.
  #
  # Verifies the authenticity of incoming MercadoPago webhook notifications by
  # recomputing the HMAC-SHA256 signature locally and comparing it against the
  # value carried in the +x-signature+ header.
  #
  # The validator is stateless, performs no outbound HTTP calls, and does not
  # depend on any SDK configuration object; the integrator passes the secret
  # signature explicitly on every call.
  #
  # @example Basic usage
  #   begin
  #     Mercadopago::Webhook::Validator.validate(
  #       request.headers['x-signature'],
  #       request.headers['x-request-id'],
  #       request.params['data.id'],
  #       webhook_secret,
  #       tolerance_seconds: 300
  #     )
  #     head :ok
  #   rescue Mercadopago::Webhook::InvalidWebhookSignatureError
  #     head :unauthorized
  #   end
  module Webhook
    # Reasons why {Validator.validate} may reject a notification. Each constant
    # is a +Symbol+; log it alongside the +x-request-id+ for correlation against
    # the MercadoPago notifications dashboard.
    module SignatureFailureReason
      MISSING_SIGNATURE_HEADER   = :missing_signature_header
      MALFORMED_SIGNATURE_HEADER = :malformed_signature_header
      MISSING_TIMESTAMP          = :missing_timestamp
      MISSING_HASH               = :missing_hash
      SIGNATURE_MISMATCH         = :signature_mismatch
      TIMESTAMP_OUT_OF_TOLERANCE = :timestamp_out_of_tolerance
    end

    # Error raised by {Validator.validate} when a webhook signature cannot be confirmed
    # as originating from MercadoPago. Carries enough context for structured logging
    # without exposing internal details in the HTTP response body.
    class InvalidWebhookSignatureError < StandardError
      # @return [Symbol] one of the {SignatureFailureReason} constants
      attr_reader :reason
      # @return [String, nil] x-request-id header value, when available
      attr_reader :request_id
      # @return [String, nil] +ts+ value extracted from the signature header
      attr_reader :timestamp

      # @param reason [Symbol] one of the {SignatureFailureReason} constants
      # @param request_id [String, nil] x-request-id value associated with the request
      # @param timestamp [String, nil] +ts+ extracted from the header
      def initialize(reason, request_id: nil, timestamp: nil)
        super("Invalid webhook signature: #{reason}")
        @reason = reason
        @request_id = request_id
        @timestamp = timestamp
      end
    end

    # Stateless utility that validates the signature of a MercadoPago webhook.
    #
    # On failure {validate} raises {InvalidWebhookSignatureError}; on success it
    # returns +nil+. The comparison is performed in constant time via
    # +OpenSSL.fixed_length_secure_compare+ to mitigate timing attacks.
    #
    # **QR Code notifications are not signed** by MercadoPago — do not call this
    # validator for those events; they will always fail signature verification.
    class Validator
      DEFAULT_SUPPORTED_VERSIONS = %w[v1].freeze
      private_constant :DEFAULT_SUPPORTED_VERSIONS

      VERSION_KEY_REGEX = /\Av\d+\z/
      private_constant :VERSION_KEY_REGEX

      # Validates the signature of a MercadoPago webhook notification.
      #
      # @param x_signature [String, nil] raw value of the +x-signature+ request header
      # @param x_request_id [String, nil] value of the +x-request-id+ request header.
      #   May be +nil+ or blank; in that case the +request-id:+ pair is omitted from
      #   the manifest before computing the HMAC
      # @param data_id [String, nil] value of the +data.id+ query parameter. May be +nil+
      #   or blank; in that case the +id:+ pair is omitted. Lowercased before HMAC
      # @param secret [String] secret signature configured in Tus Integraciones (HMAC key)
      # @param tolerance_seconds [Integer, nil] optional maximum allowed drift in seconds
      #   between the header timestamp and the current clock. Omit to skip the check
      # @param supported_versions [Array<String>, nil] optional ordered list of signature
      #   versions to accept. Defaults to +%w[v1]+. The first version found in the
      #   header is used
      # @param now [Proc, nil] optional callable returning the current time in
      #   milliseconds since Unix epoch. Intended for tests
      # @return [void]
      # @raise [InvalidWebhookSignatureError] when the signature is missing, malformed,
      #   or does not match the expected HMAC
      # @raise [ArgumentError] when +secret+ is +nil+ or empty
      def self.validate(x_signature, x_request_id, data_id, secret,
                        tolerance_seconds: nil, supported_versions: nil, now: nil)
        raise ArgumentError, 'secret must not be empty' if secret.nil? || secret.empty?

        x_signature = normalize(x_signature)
        x_request_id = normalize(x_request_id)
        data_id = normalize(data_id)
        versions = supported_versions && !supported_versions.empty? ? supported_versions : DEFAULT_SUPPORTED_VERSIONS
        now_proc = now || -> { (Time.now.to_f * 1000).to_i }

        if x_signature.nil?
          raise InvalidWebhookSignatureError.new(
            SignatureFailureReason::MISSING_SIGNATURE_HEADER,
            request_id: x_request_id
          )
        end

        ts, hashes = parse_signature_header(x_signature)

        if ts.nil? && hashes.empty?
          raise InvalidWebhookSignatureError.new(
            SignatureFailureReason::MALFORMED_SIGNATURE_HEADER,
            request_id: x_request_id
          )
        end

        if ts.nil?
          raise InvalidWebhookSignatureError.new(
            SignatureFailureReason::MISSING_TIMESTAMP,
            request_id: x_request_id
          )
        end

        unless ts.match?(/\A\d+\z/)
          raise InvalidWebhookSignatureError.new(
            SignatureFailureReason::MALFORMED_SIGNATURE_HEADER,
            request_id: x_request_id,
            timestamp: ts
          )
        end

        received_hash = nil
        versions.each do |v|
          if hashes.key?(v)
            received_hash = hashes[v]
            break
          end
        end

        if received_hash.nil?
          raise InvalidWebhookSignatureError.new(
            SignatureFailureReason::MISSING_HASH,
            request_id: x_request_id,
            timestamp: ts
          )
        end

        manifest = build_manifest(data_id, x_request_id, ts)
        computed = OpenSSL::HMAC.hexdigest('SHA256', secret, manifest)

        unless constant_time_equal(computed, received_hash)
          raise InvalidWebhookSignatureError.new(
            SignatureFailureReason::SIGNATURE_MISMATCH,
            request_id: x_request_id,
            timestamp: ts
          )
        end

        unless tolerance_seconds.nil?
          drift_ms = (now_proc.call - ts.to_i).abs
          if drift_ms > tolerance_seconds * 1000
            raise InvalidWebhookSignatureError.new(
              SignatureFailureReason::TIMESTAMP_OUT_OF_TOLERANCE,
              request_id: x_request_id,
              timestamp: ts
            )
          end
        end

        nil
      end

      # Returns the trimmed value or +nil+ for missing/whitespace inputs.
      def self.normalize(value)
        return nil if value.nil?

        text = value.to_s.strip
        text.empty? ? nil : text
      end
      private_class_method :normalize

      # Parses the +x-signature+ header into +[ts, {vN => hash}]+.
      def self.parse_signature_header(header)
        hashes = {}
        ts = nil
        header.split(',').each do |part|
          key, value = part.split('=', 2)
          next if key.nil? || value.nil?

          key = key.strip.downcase
          value = value.strip
          next if key.empty? || value.empty?

          if key == 'ts'
            ts = value
          elsif key.match?(VERSION_KEY_REGEX)
            hashes[key] = value
          end
        end
        [ts, hashes]
      end
      private_class_method :parse_signature_header

      # Constant-time string comparison. Returns +false+ for unequal-length
      # inputs without leaking the length difference via timing.
      def self.constant_time_equal(left, right)
        return false if left.bytesize != right.bytesize

        diff = 0
        left_bytes = left.bytes
        right_bytes = right.bytes
        left_bytes.each_with_index { |b, i| diff |= b ^ right_bytes[i] }
        diff.zero?
      end
      private_class_method :constant_time_equal

      # Builds the HMAC manifest, omitting empty pairs per the documented rule.
      def self.build_manifest(data_id, request_id, ts)
        parts = []
        parts << "id:#{data_id.downcase}" unless data_id.nil?
        parts << "request-id:#{request_id}" unless request_id.nil?
        parts << "ts:#{ts}"
        "#{parts.join(';')};"
      end
      private_class_method :build_manifest
    end
  end
end

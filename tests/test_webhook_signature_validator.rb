# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago/webhook/validator'
require 'openssl'
require 'minitest/autorun'

# Unit tests for {Mercadopago::Webhook::Validator}. Self-contained; no network.
class TestWebhookSignatureValidator < Minitest::Test
  SECRET = 'your_secret_key_here'
  REQUEST_ID = '2066ca19-c6f1-498a-be75-1923005edd06'
  DATA_ID_RAW = 'ORD01JQ4S4KY8HWQ6NA5PXB65B3D3'
  DATA_ID_LOWER = 'ord01jq4s4ky8hwq6na5pxb65b3d3'
  TS = '1742505638683'

  Validator = Mercadopago::Webhook::Validator
  Error = Mercadopago::Webhook::InvalidWebhookSignatureError
  Reason = Mercadopago::Webhook::SignatureFailureReason

  def compute_hash(data_id, request_id, ts, secret)
    parts = []
    parts << "id:#{data_id}" if data_id && !data_id.empty?
    parts << "request-id:#{request_id}" if request_id && !request_id.empty?
    parts << "ts:#{ts}"
    manifest = "#{parts.join(';')};"
    OpenSSL::HMAC.hexdigest('SHA256', secret, manifest)
  end

  def build_header(hash, ts = TS, version = 'v1')
    "ts=#{ts},#{version}=#{hash}"
  end

  def valid_hash
    compute_hash(DATA_ID_LOWER, REQUEST_ID, TS, SECRET)
  end

  # case 1
  def test_happy_path_lowercase
    Validator.validate(build_header(valid_hash), REQUEST_ID, DATA_ID_LOWER, SECRET)
  end

  # case 2
  def test_uppercase_dataid_is_preserved
    upper_hash = compute_hash(DATA_ID_RAW, REQUEST_ID, TS, SECRET)
    Validator.validate(build_header(upper_hash), REQUEST_ID, DATA_ID_RAW, SECRET)
  end

  # case 3
  def test_malformed_header_raises_malformed
    err = assert_raises(Error) do
      Validator.validate('this-is-garbage', REQUEST_ID, DATA_ID_LOWER, SECRET)
    end
    assert_equal Reason::MALFORMED_SIGNATURE_HEADER, err.reason
    assert_equal REQUEST_ID, err.request_id
  end

  # case 4
  def test_missing_header_raises_missing_header
    err = assert_raises(Error) do
      Validator.validate(nil, REQUEST_ID, DATA_ID_LOWER, SECRET)
    end
    assert_equal Reason::MISSING_SIGNATURE_HEADER, err.reason
  end

  # case 5
  def test_missing_ts_raises_missing_timestamp
    err = assert_raises(Error) do
      Validator.validate("v1=#{valid_hash}", REQUEST_ID, DATA_ID_LOWER, SECRET)
    end
    assert_equal Reason::MISSING_TIMESTAMP, err.reason
  end

  # case 6
  def test_missing_v1_raises_missing_hash
    err = assert_raises(Error) do
      Validator.validate("ts=#{TS}", REQUEST_ID, DATA_ID_LOWER, SECRET)
    end
    assert_equal Reason::MISSING_HASH, err.reason
    assert_equal TS, err.timestamp
  end

  # case 7
  def test_tampered_hash_raises_signature_mismatch
    h = valid_hash
    tampered = h[0..-3] + (h.end_with?('00') ? 'ff' : '00')
    err = assert_raises(Error) do
      Validator.validate(build_header(tampered), REQUEST_ID, DATA_ID_LOWER, SECRET)
    end
    assert_equal Reason::SIGNATURE_MISMATCH, err.reason
  end

  # case 8
  def test_outside_tolerance_raises
    stale_ts = ((Time.now.to_f * 1000).to_i - 30 * 60 * 1000).to_s
    h = compute_hash(DATA_ID_LOWER, REQUEST_ID, stale_ts, SECRET)
    err = assert_raises(Error) do
      Validator.validate(build_header(h, stale_ts), REQUEST_ID, DATA_ID_LOWER, SECRET,
                         tolerance_seconds: 300)
    end
    assert_equal Reason::TIMESTAMP_OUT_OF_TOLERANCE, err.reason
  end

  def test_within_tolerance_passes
    current = (Time.now.to_f * 1000).to_i.to_s
    h = compute_hash(DATA_ID_LOWER, REQUEST_ID, current, SECRET)
    Validator.validate(build_header(h, current), REQUEST_ID, DATA_ID_LOWER, SECRET,
                       tolerance_seconds: 300)
  end

  # case 9
  def test_dataid_absent_excludes_id_pair
    h = compute_hash(nil, REQUEST_ID, TS, SECRET)
    Validator.validate(build_header(h), REQUEST_ID, nil, SECRET)
  end

  # case 10
  def test_request_id_absent_excludes_request_id_pair
    h = compute_hash(DATA_ID_LOWER, nil, TS, SECRET)
    Validator.validate(build_header(h), nil, DATA_ID_LOWER, SECRET)
  end

  # case 11
  def test_both_absent_yields_ts_only
    h = compute_hash(nil, nil, TS, SECRET)
    Validator.validate(build_header(h), '', '  ', SECRET)
  end

  # case 12
  def test_non_payment_topic_uses_same_algorithm
    order_id = 'ord01abc123'
    h = compute_hash(order_id, REQUEST_ID, TS, SECRET)
    Validator.validate(build_header(h), REQUEST_ID, order_id, SECRET)
  end

  def test_supports_v1_when_both_present
    header = "ts=#{TS},v1=#{valid_hash},v2=aaaa"
    Validator.validate(header, REQUEST_ID, DATA_ID_LOWER, SECRET, supported_versions: %w[v1])
  end

  def test_only_v2_in_header_only_v1_supported_raises_missing_hash
    header = "ts=#{TS},v2=somehash"
    err = assert_raises(Error) do
      Validator.validate(header, REQUEST_ID, DATA_ID_LOWER, SECRET, supported_versions: %w[v1])
    end
    assert_equal Reason::MISSING_HASH, err.reason
  end

  def test_empty_secret_raises_argument_error
    assert_raises(ArgumentError) do
      Validator.validate(build_header(valid_hash), REQUEST_ID, DATA_ID_LOWER, '')
    end
  end
end

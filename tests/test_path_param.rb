# typed: true
# frozen_string_literal: true

require_relative '../lib/mercadopago'

require 'minitest/autorun'

class TestPathParam < Minitest::Test
  def test_path_param_escapes_path_traversal
    base = Mercadopago::MPBase.new(Mercadopago::RequestOptions.new(access_token: 'token'), nil)

    assert_equal '..%2F..%2Fapplications%2F123', base.send(:_path_param, '../../applications/123')
  end
end

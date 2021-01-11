require_relative './tests/resources/test_preference'


class MercadoPagoTest < Minitest::Test
  def test_all
    test_preference.test_method_get
  end
end
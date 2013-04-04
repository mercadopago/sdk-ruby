require 'test/unit'
require 'mercadopago'
require 'logger'

class MercadoPagoTest < Test::Unit::TestCase
  def setup
	  @mp = MercadoPago.load_from_config
    # @mp.set_debug_logger(Logger.new(File.join(File.dirname(__FILE__), 'debug.log')))
  end
	
	# Create a new preference and verify that data result are ok
	def test_create_preference
		preference_data = {"items" => ["title"=>"testCreate", "quantity"=>1, "unit_price"=>10.2, "currency_id"=>"ARS"]}
	
		preference = @mp.create_preference(preference_data)
		assert_equal "201", "#{preference['status']}"
		assert_equal "testCreate", "#{preference['response']["items"][0]["title"]}"
	end
	
	# We create a new preference, we modify this one and then we verify that data are ok.
	def test_update_preference
		preference_data = {"items" => ["title"=>"testUpdate", "quantity"=>1, "unit_price"=>10.2, "currency_id"=>"ARS"]}
		preference_created = @mp.create_preference(preference_data)
		preference_to_update = @mp.get_preference("#{preference_created['response']['id']}")
		
		preference_data_to_update = {"items" => ["title"=>"testUpdated", "quantity"=>1, "unit_price"=>2]}
		preference_update = @mp.update_preference("#{preference_created['response']['id']}", preference_data_to_update)
		assert_equal "200", "#{preference_update['status']}"
		
		preference_to_update = @mp.get_preference("#{preference_created['response']['id']}")
		
		assert_equal "testUpdated", "#{preference_to_update['response']["items"][0]["title"]}"
		assert_equal "2", "#{preference_to_update['response']["items"][0]["unit_price"]}"
		assert_equal "1", "#{preference_to_update['response']["items"][0]["quantity"]}"
		assert_equal "ARS", "#{preference_to_update['response']["items"][0]["currency_id"]}"
	end
end

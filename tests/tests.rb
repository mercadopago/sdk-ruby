require "test/unit"

$LOAD_PATH << '../lib'
require 'mercadopago.rb'
 
class TestUnit < Test::Unit::TestCase
 
	$mp = MercadoPago.new('CLIENT_ID', 'CLIENT_SECRET')
	
	# Call preference added through button flow
	def test_get_preference
		preference = $mp.get_preference('ID')
		
		assert_equal("#{preference['status']}","200")
	end
	
	# Create a new preference and verify that data result are ok
	def test_create_preference
		preferenceData = Hash["items" => Array(Array["title"=>"testCreate", "quantity"=>1, "unit_price"=>10.2, "currency_id"=>"ARS"])]
	
		preference = $mp.create_preference(preferenceData)
		assert_equal("#{preference['status']}","201")
		assert_equal("#{preference['response']["items"][0]["title"]}","testCreate")
	end
	
	# We create a new preference, we modify this one and then we verify that data are ok.
	def test_update_preference
		preferenceData = Hash["items" => Array(Array["title"=>"testUpdate", "quantity"=>1, "unit_price"=>10.2, "currency_id"=>"ARS"])]
		preferenceCreated = $mp.create_preference(preferenceData)
		preferenceToUpdate = $mp.get_preference("#{preferenceCreated['response']['id']}")
		
		preferenceDataToUpdate = Hash["items" => Array(Array["title"=>"testUpdated", "quantity"=>1, "unit_price"=>2])]
		preferenceUpdate = $mp.update_preference("#{preferenceCreated['response']['id']}", preferenceDataToUpdate)
		assert_equal("#{preferenceUpdate['status']}","200")
		
		preferenceToUpdate = $mp.get_preference("#{preferenceCreated['response']['id']}")
		
		assert_equal("#{preferenceToUpdate['response']["items"][0]["title"]}","testUpdated")
		assert_equal("#{preferenceToUpdate['response']["items"][0]["unit_price"]}","2")
		assert_equal("#{preferenceToUpdate['response']["items"][0]["quantity"]}","1")
		assert_equal("#{preferenceToUpdate['response']["items"][0]["currency_id"]}","ARS")
	end
end

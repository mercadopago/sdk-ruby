
require 'rubygems'
require 'json'
require 'uri'
require 'net/https'
require 'yaml'
require File.dirname(__FILE__) + '/version'
require 'ssl_options_patch'
require 'card'
require 'cardtoken'
require 'customer'
require 'discountcampaign'
require 'genericcall'
require 'identificationtype'
require 'merchantorder'
require 'payment'
require 'preapproval'
require 'preference'

class MercadoPago
	attr_reader :card, :cardtoken, :customer, :discountcampaign, :genericcall, :identificationtype, :merchantorder, :payment, :preference
	@@sandbox = false
	def initialize(*args)
		if args.size < 1 or args.size > 2
			raise "Invalid arguments. Use CLIENT_ID and CLIENT SECRET, or ACCESS_TOKEN"
		end

		@client_id = args.at(0) if args.size == 2
		@client_secret = args.at(1) if args.size == 2
		@ll_access_token = args.at(0) if args.size == 1

		@card = Card.new(@client_id, @client_secret, @ll_access_token)
		@cardtoken = CardToken.new(@client_id, @client_secret, @ll_access_token)
		@customer = Customer.new(@client_id, @client_secret, @ll_access_token)
		@discountcampaign = DiscountCampaign.new(@client_id, @client_secret, @ll_access_token)
		@genericcall = GenericCall.new(@client_id, @client_secret, @ll_access_token)
		@identificationtype = IdentificationType.new(@client_id, @client_secret, @ll_access_token)
		@merchantorder = MerchantOrder.new(@client_id, @client_secret, @ll_access_token)
		@payment = Payment.new(@client_id, @client_secret, @ll_access_token)
		@preference = Preference.new(@client_id, @client_secret, @ll_access_token)
	end

	def sandbox_mode(enable=nil)
		if not enable.nil?
			@@sandbox = enable
		end

		return @@sandbox
	end

	def self.sandbox
		@@sandbox
	end
end

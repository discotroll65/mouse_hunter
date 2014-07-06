class Sponsorship < ActiveRecord::Base
	belongs_to :politician
	belongs_to :bill

	def self.get_sponsorship
		# get help with API reading
		response = RestClient.get("")
		parsed_response = JSON.parse(response)
		sponsorships = parsed_response[""]
		sponsorships
	end
end

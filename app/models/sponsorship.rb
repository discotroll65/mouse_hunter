class Sponsorship < ActiveRecord::Base
	def self.get_sponsorship
		# get help with API reading
		response = RestClient.get("")
		parsed_response = JSON.parse(response)
		sponsorships = parsed_response[""]
		sponsorships
	end
end

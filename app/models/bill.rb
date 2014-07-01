class Bill < ActiveRecord::Base
	def self.get_bills
		# get help with API reading
		response = RestClient.get("")
		parsed_response = JSON.parse(response)
		bills = parsed_response[""]
		bills
	end
end

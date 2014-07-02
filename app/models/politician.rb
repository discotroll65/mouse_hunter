class Politician < ActiveRecord::Base
	def self.get_politicians
		response = RestClient.get("http://congress.api.sunlightfoundation.com/legislators/locate?zip=19035&apikey=64177a5c45dc44eb8752332b15fb89bf")
		parsed_response = JSON.parse(response)
		politicians = parsed_response["results"]
		politicians
	end
end

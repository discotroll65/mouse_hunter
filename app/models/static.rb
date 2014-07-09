class Static < ActiveRecord::Base
	
	 def self.get_politicians_by_query(query)
		#binding.pry
		
		response = RestClient.get("http://congress.api.sunlightfoundation.com/legislators?query=#{query}&apikey=#{ENV["SUNLIGHT_API"]}")
		parsed_response = JSON.parse(response)
		politicians = parsed_response["results"]
    #binding.pry
		politicians
	end
end

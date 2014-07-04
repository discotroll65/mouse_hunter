class Politician < ActiveRecord::Base
	def self.get_politicians
		
		#zipcode is hardwired in currently
		response = RestClient.get("http://congress.api.sunlightfoundation.com/legislators/locate?zip=12009&apikey=64177a5c45dc44eb8752332b15fb89bf")
		parsed_response = JSON.parse(response)
		politicians = parsed_response["results"]
		politicians
	end

	def ordinalize
		number = self.to_i
        if (11..13).include?(number % 100)
                "#{self}th"
        else
            case number % 10
                when 1 
                	"#{self}st"
                when 2 
                	"#{self}nd"
                when 3 
                	"#{self}rd"
                else   
                	"#{self}th"
            end
        end

   end

   def symbol
   		if self.party_finder == "Democrat"
   			return "donkey.png"
   		elsif self.party_finder == "Republican"
   			return "elephant.png"
   		else 
   			" "
   		end
   end

   def party_finder
   		party_letter = self.party
		if party_letter[0] == "D"
			"Democrat"
		elsif party_letter[0] == "R"
			"Republican"
		elsif party_letter[0] == "I"
			"Independent"
		else
			" "
		end
   end

end

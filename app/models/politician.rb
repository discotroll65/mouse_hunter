class Politician < ActiveRecord::Base
	def self.get_politicians(zip)
		
		#zipcode is hardwired in currently
		response = RestClient.get("http://congress.api.sunlightfoundation.com/legislators/locate?zip=#{zip}&apikey=64177a5c45dc44eb8752332b15fb89bf")
		parsed_response = JSON.parse(response)
		politicians = parsed_response["results"]
		politicians
	end

	def self.get_basic_info
		response = RestClient.get("http://api.nytimes.com/svc/politics/v3/us/legislative/congress/113/#{@politician.chamber}/members.json?&state=#{@politician.state}&api-key=64530e3bc4c658192fb76270ca3b8eba:5:69549341")
		parsed_response = JSON.parse(response)
		politicians_basic_stats = parsed_response["results"]["members"]
		politicians_basic_stats
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
   		if self.party_finder == "democrat"
   			return "donkey.png"
   		elsif self.party_finder == "republican"
   			return "elephant.png"
   		else 
   			" "
   		end
   end

   def party_finder
   		party_letter = self.party
		if party_letter[0] == "D"
			"democrat"
		elsif party_letter[0] == "R"
			"republican"
		elsif party_letter[0] == "I"
			"independent"
		else
			" "
		end
   end

    def check_if_senator
	    if self.district
	   		"'s " + "#{self.district.to_i.ordinalize}" + " district"
		else 
			" "
		end
	end

	validates_uniqueness_of :congress_cid
end

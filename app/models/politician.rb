class Politician < ActiveRecord::Base
	def self.get_politicians(zip)
		
		#zipcode is hardwired in currently
		response = RestClient.get("http://congress.api.sunlightfoundation.com/legislators/locate?zip=#{zip}&apikey=64177a5c45dc44eb8752332b15fb89bf")
		parsed_response = JSON.parse(response)
		politicians = parsed_response["results"]
		politicians
	end

<<<<<<< HEAD
=======
	def get_info_from_NYT
    #NYTimes api key
    api_key = "64530e3bc4c658192fb76270ca3b8eba:5:69549341"

    #use the info from the sunlight foundation to look up current member for state info from the NYT

    response = RestClient.get("http://api.nytimes.com/svc/politics/v3/us/legislative/congress/members/#{self.chamber}/#{self.state}/#{self.district}/current.json?api-key=#{api_key}")
    
    #Handles case where Congress person is from House or Senate
    if self.chamber == "house"
      parsed_response = JSON.parse(response)["results"][0]
    else
      #if Person is in the senate, will have an array of 2 senators. Check the last name of the person for each one
      @senator_index= nil


      JSON.parse(response)["results"].each_with_index do |senator, index|
        if self.last_name == senator["name"].split.last
          @senator_index = index
        end
      end

      parsed_response = JSON.parse(response)["results"][@senator_index]
    end   

    #assigns NYT id and next election date
    self["NYT_id"] = parsed_response["id"]
    self.update_attributes(next_election: parsed_response["next_election"])

    detailed_info = RestClient.get("http://api.nytimes.com/svc/politics/v3/us/legislative/congress/members/#{self.NYT_id}.json?api-key=#{api_key}")
    parsed_detailed_info = JSON.parse(detailed_info)

    # self.update_attributes(seniority: parsed_detailed_info["results"][0]["roles"]["seniority"])

    # ,missed_votes_pct: parsed_detailed_info["results"][0]["roles"]["missed_votes_pct"], votes_with_party_pct: parsed_detailed_info["results"][0]["roles"]["votes_with_party_pct"], facebook_account: parsed_detailed_info["results"][0]["facebook_account"]

    self

  end


>>>>>>> 35134583299773bfa35d104ca91340b53ca3a31f


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

class Politician < ActiveRecord::Base
  has_many :sponsorships
  has_many :pvotes
  has_many :lobbies
  has_many :donors, :through => :lobbies
  has_many :sponsored_bills, :through => :sponsorships, :source => :bill, :dependent => :destroy
  has_many :voted_bills, :through => :pvotes, :source => :bill

	
  def self.get_politicians_by_zip(zip)
		#binding.pry
		
		response = RestClient.get("http://congress.api.sunlightfoundation.com/legislators/locate?zip=#{zip}&apikey=#{ENV["SUNLIGHT_API"]}")
		parsed_response = JSON.parse(response)
		politicians = parsed_response["results"]
    #binding.pry
		politicians
	end


#This goes over an array returned by the method "get_politicians_by_zip", which contains hashes of politicians, and then creates active records of them using various API pulls. It also generates all the bills a politician has sponsored. A validate uniqueness in the politician and bill models make sure that duplicates don't happen. Method returns an array of Active records.
    
  def self.get_all_data_for_politicians(array_of_politician_hashes)
    #initialize array to be returned
    politician_active_records = []

    array_of_politician_hashes.each do |politician|

      politician_active_records << Politician.create(name: (politician["first_name"] + " " + politician["last_name"]), first_name: politician["first_name"], last_name: politician["last_name"], district: politician["district"], state: politician["state"], title: politician["title"], twitter_id: politician["twitter_id"], in_office: politician["in_office"], contact_form: politician["contact_form"], party: politician["party"], congress_cid: politician["crp_id"], chamber: politician["chamber"], bioguide_id: politician["bioguide_id"])
      #binding.pry
      #Gets all the data for Politician record from NYT
     Politician.last.get_info_from_NYT
    end

    politician_active_records
  end

  #instance method that updates that instance's info using api calls from the sunlight foundation and NYT apis
	def get_info_from_NYT
    #binding.pry

    response = RestClient.get("http://api.nytimes.com/svc/politics/v3/us/legislative/congress/members/#{self.chamber}/#{self.state}/#{self.district}/current.json?api-key=#{ENV["NYT_API"]}")
    
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
    self.update_attributes(next_election: parsed_response["next_election"])

    detailed_info = RestClient.get("http://api.nytimes.com/svc/politics/v3/us/legislative/congress/members/#{self.bioguide_id}.json?api-key=#{ENV["NYT_API"]}")
    parsed_detailed_info = JSON.parse(detailed_info)

    self.update_attributes(seniority: parsed_detailed_info["results"][0]["roles"][0]["seniority"],missed_votes_pct: parsed_detailed_info["results"][0]["roles"][0]["missed_votes_pct"], votes_with_party_pct: parsed_detailed_info["results"][0]["roles"][0]["votes_with_party_pct"], facebook_account: parsed_detailed_info["results"][0]["facebook_account"])

    #Get bills this politician has sponsored
    bills_sponsored = []


    bill_info = RestClient.get("http://congress.api.sunlightfoundation.com/bills?sponsor_id=#{self.bioguide_id}&apikey=#{ENV["SUNLIGHT_API"]}&page=1")
    parsed_bill_info = JSON.parse(bill_info)
    #count how many pages there are
    counter = (parsed_bill_info["count"].to_f / parsed_bill_info["page"]["per_page"].to_f).ceil
     

    #go through all the pages of the bills the politician has sponsored
    parsed_bill_info["results"].each do |bill|
        bills_sponsored << Bill.create(title: bill["#{
              bill["short_title"] ? "short_title" : "official_title"
              }" ] , issue: bill["committee_ids"][0], status: "enacted?" + "#{bill["history"]["enacted"]}")
        #description: "URL for description: #{bill["urls"]["govtrack"]}"
      end

    if counter > 1
      
      2.upto(counter) do |time|
        bill_info_loop = RestClient.get("http://congress.api.sunlightfoundation.com/bills?sponsor_id=#{self.bioguide_id}&apikey=#{ENV["SUNLIGHT_API"]}&page=#{time}")
        parsed_bill_info_loop = JSON.parse(bill_info_loop)
        parsed_bill_info_loop["results"].each do |bill|
          bills_sponsored << Bill.create(title: bill["#{
              bill["short_title"] ? "short_title" : "official_title"
              }" ] , issue: bill["committee_ids"][0], status: "enacted? " + "#{bill["history"]["enacted"]}")
        end
      end

    end

    self.sponsored_bills = bills_sponsored

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

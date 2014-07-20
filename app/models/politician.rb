class Politician < ActiveRecord::Base
  has_many :posts
  has_many :sponsorships
  has_many :pvotes
  has_many :influences
  has_many :assignments
  has_many :committees, :through => :assignments
  has_many :lobbies, :through => :influences
  has_many :donors, :through => :lobbies
  has_many :sponsored_bills, :through => :sponsorships, :source => :bill, :dependent => :destroy
  has_many :voted_bills, :through => :pvotes, :source => :bill
  validates_uniqueness_of :bioguide_id

  
  def self.get_politicians_hash(query)
    if Politician.is_zip?(query)
      response = RestClient.get("http://congress.api.sunlightfoundation.com/legislators/locate?zip=#{query}&apikey=#{ENV["SUNLIGHT_API"]}")
      parsed_response = JSON.parse(response)
      politicians = parsed_response["results"]
      #binding.pry
      politicians

    else  
      if query.split.count > 1
        query = query.split[1]
      end

      response = RestClient.get("http://congress.api.sunlightfoundation.com/legislators?query=#{query}&apikey=#{ENV["SUNLIGHT_API"]}")
      parsed_response = JSON.parse(response)
      politicians = parsed_response["results"]
      #binding.pry
      politicians
    end

  end

  def self.make_politicians_in_db(politicians_hash)
    #initializes what will be an array of instantiated politican records
    politicians_array = []

      
    #Making an array of initialized Politician active records
    politicians_hash.each do |politician|
      
      politicians_array << Politician.new(name: (politician["first_name"] + " " + politician["last_name"]), first_name: politician["first_name"], last_name: politician["last_name"], district: politician["district"], state: politician["state"], title: politician["title"], twitter_id: politician["twitter_id"], in_office: politician["in_office"], contact_form: politician["contact_form"], party: politician["party"], congress_cid: politician["crp_id"], chamber: politician["chamber"], bioguide_id: politician["bioguide_id"])
    end

    #saves array in db, if already exists, grabs that one in array
    politicians_array.each_with_index do |politician, index|
      
      if !politician.save
        politicians_array[index] = Politician.where(:bioguide_id => politician.bioguide_id)[0]
      end
    end
    politicians_array
  end

  # CHecks to see if the query input is an interger (meaning a zipcode)

  def self.is_zip?(query)
    !!(query =~ /\A(\s+)?[0-9]{5}([-][0-9]{4})?(\s+)?\z/)
  end

# This is a hash of all the demo politicians and their assigned twitter_widget_id 

def self.twitter_widget_id
    politicians = {
      "Brad Sherman" => "486908157516476417",
      "Barbara Boxer" => "486825057671335937", 
      "Diane Feinstein" => "486908613877719041",
      "Patrick Toomey" => "486909225101037568",
      "Allyson Schwartz" => "486933279988129793",
      "Chaka Fattah" => "486937089607348224",
      "Robert Casey" => "486937489819435009",
      "Patrick Meehan" => "487532918676279297"

    }


end

def get_twitter_id(politician_twitter_hash, politician)
  politician_twitter_hash.each do |name, data_widget_id| 
      name = politician.name 
      data_widget_id
  end   
end 



  #This goes over an array returned by the method "get_politicians_by_zip", which contains hashes of politicians, and then creates active records of them using various API pulls. It also generates all the bills a politician has sponsored. A validate uniqueness in the politician and bill models make sure that duplicates don't happen. Method returns an array of Active records.
    
  def get_all_data_for_politicians
    #initialize array to be returned
     

    @queries = ["jobs", "health", "education", "security", "veterans", "immigration", "military", "unions", "taxes", "agriculture"]
    #John Boehner was 2:42 with queries
    # 8 seconds without queries
    # @queries.each do |query|
    #   self.get_ideology(query)
    # end

    self.get_info_from_NYT
    self.get_campaign_finance
    self.get_committee_info
  end

  #instance method that updates that instance's info using api calls from the sunlight foundation and NYT apis
  def get_info_from_NYT

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
        
        bill_instance = Bill.new(title: bill["#{
              bill["short_title"] ? "short_title" : "official_title"
              }" ] , issue: bill["committee_ids"][0], status: "enacted?" + "#{bill["history"]["enacted"]}", official_title: bill["official_title"], url: bill["urls"]["govtrack"], bill_id: bill["bill_id"], congress: bill["congress"])

        if bill_instance.save
          bills_sponsored << bill_instance
          
        else
          #binding.pry
          bills_sponsored << Bill.where(bill_id: bill["bill_id"])
        
        end        
    end


     if counter > 1
      
      2.upto(counter) do |time|
        bill_info_loop = RestClient.get("http://congress.api.sunlightfoundation.com/bills?sponsor_id=#{self.bioguide_id}&apikey=#{ENV["SUNLIGHT_API"]}&page=#{time}")

        parsed_bill_info_loop = JSON.parse(bill_info_loop)
        parsed_bill_info_loop["results"].each do |bill|
          bill_instance = Bill.new(title: bill["#{
              bill["short_title"] ? "short_title" : "official_title"
              }" ] , issue: bill["committee_ids"][0], status: "enacted?" + "#{bill["history"]["enacted"]}", official_title: bill["official_title"], url: bill["urls"]["govtrack"], bill_id: bill["bill_id"], congress: bill["congress"])

          if bill_instance.save
            bills_sponsored << bill_instance
            
          else
            #binding.pry
            bills_sponsored << Bill.where(bill_id: bill["bill_id"])
          
          end
        end
      end

    end

    self.sponsored_bills = bills_sponsored
  end

  def get_ideology(query)
    bill_id_array = []
    short_title_array = []
    votes_for_bills_of_query = []
    bills_with_votes = {}
    bills_voted = []
    
    # get four of the bills with the given issue/query
    if self.chamber == "house"
      bill_url = "https://congress.api.sunlightfoundation.com/bills?query=#{query}&congress=113&history.house_passage_result=pass&apikey=#{ENV["SUNLIGHT_API"]}"
    else
      bill_url = "https://congress.api.sunlightfoundation.com/bills?query=#{query}&congress=113&history.senate_passage_result=pass&apikey=#{ENV["SUNLIGHT_API"]}"
    end

    bills_under_query = RestClient.get("#{bill_url}")


    parsed_bills_under_query = JSON.parse(bills_under_query)
    results = parsed_bills_under_query["results"]
   
    #binding.pry
    counter = 0
   
    results.each do |bill|

      rounds = RestClient.get("https://congress.api.sunlightfoundation.com/votes?&bill_id=#{bill["bill_id"]}&fields=voter_ids&apikey=#{ENV["SUNLIGHT_API"]}")
      parsed_rounds = JSON.parse(rounds)
      round_results = parsed_rounds["results"]
        #binding.pry
      if round_results[0] == nil
        #binding.pry
        next
      else
        bill_instance = Bill.new(title: bill["#{
          bill["short_title"] ? "short_title" : "official_title"
          }" ] , issue: query, status: "enacted?" + "#{bill["history"]["enacted"]}", official_title: bill["official_title"], url: bill["urls"]["govtrack"], bill_id: bill["bill_id"], congress: bill["congress"], voted_on: "yes")

        counter += 1
      end
        #binding.pry
      if bill_instance.save
        self.voted_bills << bill_instance
        #binding.pry
        Pvote.last.update_attributes(issue: query, vote: round_results[0]["voter_ids"][self.bioguide_id])
      else
        #binding.pry
        self.voted_bills << Bill.where(bill_id: bill["bill_id"])
        Pvote.last.update_attributes(issue: query, vote: round_results[0]["voter_ids"][self.bioguide_id])
      end
      
      break unless counter < 3
      #binding.pry
    end
    #binding.pry
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


  def get_committee_info
    #use API to get the committee info about the congress person
    committee_info = RestClient.get("http://congress.api.sunlightfoundation.com/committees?member_ids=#{self.bioguide_id}&apikey=#{ENV["SUNLIGHT_API"]}")
    parsed_committee_info = JSON.parse(committee_info)

    #initialize committee array
    congress_reps_committees = []

    #go through each committee, suck out name and code, shovel into congress _reps_committees
    parsed_committee_info["results"].each do |committee|
      #checks if there is a sub committee
      subcommittee_status = "false"

      if committee["committee_id"].length > 4
        subcommittee_status = "true"
      end

        #Shovels committees in as unsaved instances
      congress_reps_committees << Committee.new(name: committee["name"], committee_code: committee["committee_id"], is_subcommittee: subcommittee_status)
    end

    #go through each committee, save it if it doesn't already exist, associate it with politician
    congress_reps_committees.each do |committee_record|
      if committee_record.save
        self.committees << Committee.last 
        else
        self.committees << Committee.where(:name => committee_record.name) 
      end
    end

  end


  def get_campaign_finance
    campaign_entered = "2012"
    #API to get summary of how much the politician raised last cycle
  
    response = RestClient.get("http://www.opensecrets.org/api/?method=candSummary&cid=#{self.congress_cid}&cycle=2012&apikey=#{ENV["OPENSECRETS_API"]}&output=json")

    parsed_response = JSON.parse(response)

    #gets the amount of money the candidate raised last election
    total_money_raised = parsed_response["response"]["summary"]["@attributes"]["total"]
    self.update_attributes(money_raised: total_money_raised)


    #API to get top industries contributing to a politician
    contributers_info = RestClient.get("http://www.opensecrets.org/api/?method=candIndustry&cid=#{self.congress_cid}&cycle=#{campaign_entered}&apikey=#{ENV["OPENSECRETS_API"]}&output=json")
    parsed_contributers_info = JSON.parse(contributers_info)

    campaign_contributers = []

    #go through industries that have donated to the politician
    parsed_contributers_info["response"]["industries"]["industry"].each do |industry|
        
      lobby_instance = Lobby.new(industry_code: industry["@attributes"]["industry_code"], industry_name: industry["@attributes"]["industry_name"])
        
      if lobby_instance.save
        self.lobbies << Lobby.last
        Influence.last.update_attributes(:campaign_cycle => campaign_entered, :money_given => industry["@attributes"]["total"])
      else
        self.lobbies << Lobby.where(:industry_code => lobby_instance.industry_code)
        Influence.last.update_attributes(:campaign_cycle => campaign_entered, :money_given => industry["@attributes"]["total"])
      end
        #add later --description: "URL for description: #{bill["urls"]["govtrack"]}"
    end
  end

end





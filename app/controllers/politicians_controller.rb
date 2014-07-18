
class PoliticiansController < ApplicationController 
	require 'googlecharts'

	def index

		#check if query is a zipcode
		if Politician.is_i?(params[:query])
		  api_mode = "zip"
		else
			api_mode = "query"
		end 

		
		#assumes user entered a zipcode
		if api_mode == "zip"

			@zipcode = params[:query]
		 
			#Initialize what will be an array of active records
			@politicians_zip = []


			#after the user enters a zipcode,
			#politicians_zip_hash is an array of Politician Hashes
			politicians_zip_hash = Politician.get_politicians_by_zip(@zipcode)

			
			#Making an array of initialized Politician active records
			politicians_zip_hash.each do |politician|
				
				@politicians_zip << Politician.new(name: (politician["first_name"] + " " + politician["last_name"]), first_name: politician["first_name"], last_name: politician["last_name"], district: politician["district"], state: politician["state"], title: politician["title"], twitter_id: politician["twitter_id"], in_office: politician["in_office"], contact_form: politician["contact_form"], party: politician["party"], congress_cid: politician["crp_id"], chamber: politician["chamber"], bioguide_id: politician["bioguide_id"])
			end

			@politicians_zip.each_with_index do |politician, index|
				
				if !politician.save
					@politicians_zip[index] = Politician.where(:bioguide_id => politician.bioguide_id)[0]
				end
			end


			

		else	
				  #Data in the Politician table is currently populated/saved by running 'rake db:seed' in the terminal, which does an API call that hardwires in the reps from zipcode 12009##	
			if params[:query].split.count == 2
				@query = params[:query].split[1]
			else
				@query = params[:query]
			end
		 
			#Initialize what will be an array of active records
			@politicians_query = []


			
			#politicians_zip_ an array of Politician Hashes
			politicians_query_hash = Politician.get_politicians_by_query(@query)

			
			#Making an array of initialized Politician active records
			politicians_query_hash.each do |politician|
				
				@politicians_query << Politician.new(name: (politician["first_name"] + " " + politician["last_name"]), first_name: politician["first_name"], last_name: politician["last_name"], district: politician["district"], state: politician["state"], title: politician["title"], twitter_id: politician["twitter_id"], in_office: politician["in_office"], contact_form: politician["contact_form"], party: politician["party"], congress_cid: politician["crp_id"], chamber: politician["chamber"], bioguide_id: politician["bioguide_id"])
			end

			@politicians_query.each_with_index do |politician, index|
				
				if !politician.save
					@politicians_query[index] = Politician.where(:bioguide_id => politician.bioguide_id)[0]
				end
			end
			

		end	
			#binding.pry

	end

	def show
		####  GETS INFO FOR THE POLITICIANS  ###### 
		@politician = Politician.find(params[:id])
		
		if @politician.sponsored_bills.count == 0
			@politician.get_all_data_for_politicians
		end

		@politician_twitter_hash = Politician.twitter_widget_id

		post = Post.new(:body => params[:comment])
		
		if params[:comment] != nil
			@politician.posts << Post.new(:body => params[:comment])
		end
		

		@queries = ["jobs", "health", "education", "security", "veterans", "immigration", "military", "unions", "taxes", "agriculture"]
		@ideologies = {}

		# @queries.each do |query, index|
		# 	# ideologies is a hash with a key that is the query and a valeu that is a hash (keys are bill ids and values are votes)
		# 	@ideologies[query] = @politician.get_ideology(query)
			
		# end
		@queries.each do |query|
		  vote_hash = {}
			@politician.pvotes.each do |politician_vote|
			  
				if politician_vote.issue == query
					vote_hash[politician_vote.bill.title] = politician_vote["vote"]
				end
			end
		  @ideologies[query] = vote_hash

		end
	
	
		@donors_bar_graph = Gchart.pie(:data => [0, 40, 10, 70, 20])
		@counts = Donor.distinct.group(:industry).count

		# @donors_bar_graph = Gchart.pie(:data => [0, 40, 10, 70, 20]):title => @title, :labels => @legend, :data => @data, :size => '400x200'
		
		@donors_bar_graph = Gchart.pie(:data => [0, 40, 10, 70, 20])
		@counts = Donor.distinct.group(:industry).count


		#get an array of the industries and what they gave
		@counts = @politician.influences.map do |influence|
			[influence.lobby.industry_name, influence.money_given.to_i]
		end
		
		#initialize variable that is the sum of all the money top industries donated
		top_industry_total_given = 0
		
		@counts.each do |count|
			top_industry_total_given += count[1].to_i
		end
	
		# other_sources = @politician.money_raised - top_industry_total_given
		# @counts << ["Other sources", other_sources]
		

		@counts = @counts.to_h


		@efficiency = {:bills_passed => 0, :bills_sponsored => @politician.sponsored_bills.count, :years_in_congress => @politician.seniority}

		@politician.sponsored_bills.each do |bill|
		   if (bill.status.match /true/)  
		     @efficiency[:bills_passed] += 1.0    
		     @efficiency["bill_id#{@efficiency[:bills_passed]}".to_sym] = bill.id
		   end  
		end 

	end


	private
	 def task_params
      params.require(:post).permit(:comment)
     end

end	

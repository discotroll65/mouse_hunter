
class PoliticiansController < ApplicationController 
	require 'googlecharts'

	def index


		if Politician.is_i?(params[:query])
		  api_mode = "zip"
		else
			api_mode = "query"
		end 

		

		if api_mode == "zip"

	  		#Data in the Politician table is currently populated/saved by running 'rake db:seed' in the terminal, which does an API call that hardwires in the reps from zipcode 12009##	
			@politicians = Politician.all
			@zipcode = params[:query]
		 
			#Initialize what will be an array of active records
			@politicians_zip = []


			#when first visting /politicans, this is empty, but after the user enters a zipcode,
			#politicians_zip_ an array of Politician Hashes
			politicians_zip_hash = Politician.get_politicians_by_zip(@zipcode)

			
			#Making an array of initialized Politician active records
			politicians_zip_hash.each do |politician|
				
				@politicians_zip << Politician.new(name: (politician["first_name"] + " " + politician["last_name"]), first_name: politician["first_name"], last_name: politician["last_name"])
				end

			#checks for when the user first gets to the page
			if politicians_zip_hash.count != 0
				#checks to see if the politicians are already in the Database
				number_of_matches = 0

				@politicians_zip.each do |politician|
					number_of_matches += Politician.where(:last_name => politician.last_name).count
					
				end
				puts "Number of matches = #{number_of_matches}"
				#if politicians are not in the database, create them, get their data
				if number_of_matches != @politicians_zip.count
				 @politicians_zip = Politician.get_all_data_for_politicians(politicians_zip_hash)
				end
			end

		else	
				  #Data in the Politician table is currently populated/saved by running 'rake db:seed' in the terminal, which does an API call that hardwires in the reps from zipcode 12009##	
			@politicians = Politician.all
			if params[:query].split.count == 2
				@query = params[:query].split[1]
			else
				@query = params[:query]
			end
		 
			#Initialize what will be an array of active records
			@politicians_query = []


			#when first visting /politicans, this is empty, but after the user enters a zipcode,
			#politicians_zip_ an array of Politician Hashes
			politicians_query_hash = Politician.get_politicians_by_query(@query)

			
			#Making an array of initialized Politician active records
			politicians_query_hash.each do |politician|
				
				@politicians_query << Politician.new(name: (politician["first_name"] + " " + politician["last_name"]), first_name: politician["first_name"], last_name: politician["last_name"])
			end
				
			#checks for when the user first gets to the page
				if politicians_query_hash.count != 0
				#checks to see if the politicians are already in the Database
				number_of_matches = 0

				@politicians_query.each do |politician|
					number_of_matches += Politician.where(:last_name => politician.last_name).count
					
				end
				puts "Number of matches = #{number_of_matches}"
				#if politicians are not in the database, create them, get their data
				if number_of_matches != @politicians_query.count
				 @politicians_query = Politician.get_all_data_for_politicians(politicians_query_hash)
				end
			end
			

		end	
			#binding.pry

	end

	def show
		@politician_twitter_hash = Politician.twitter_widget_id
		@politician = Politician.find(params[:id])
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

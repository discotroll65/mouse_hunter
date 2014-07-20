
class PoliticiansController < ApplicationController 
	require 'googlecharts'

	def index

		@query = params[:query]
		
		politicians_hash = Politician.get_politicians_hash(@query)

		@politicians_array = Politician.make_politicians_in_db(politicians_hash)
		
		
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

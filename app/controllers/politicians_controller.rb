
class PoliticiansController < ApplicationController 
	require 'googlecharts'

	def index
	  #Data in the Politician table is currently populated/saved by running 'rake db:seed' in the terminal, which does an API call that hardwires in the reps from zipcode 12009##	
		@politicians = Politician.all
		@zipcode = params[:zipcode]
	 
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
				#binding.pry
			end
			puts "Number of matches = #{number_of_matches}"
			#if politicians are not in the database, create them, get their data
			if number_of_matches != @politicians_zip.count
			 @politicians_zip = Politician.get_all_data_for_politicians(politicians_zip_hash)
			end
		end



		#binding.pry
	end

	def show
		@politician = Politician.find(params[:id])
		@queries = ["jobs"]
		# , "health", "education", "economy", "energy", "transportation", "veteran", "security", "environment", "agriculture", "women", "minority", "budget", "tax"
		@ideologies = {}
		@queries.each_with_index do |query, index|
			# ideologies is an array with each element being an array of strings that represent votes to four bills
			# looks like this {01 => ["yea","nay", "yeah", "nay"],["yea","nay", "yeah", "nay"]}
			@ideologies[index] = @politician.get_ideology(query)
			binding.pry
		end
		
		@donors_bar_graph = Gchart.pie(:data => [0, 40, 10, 70, 20])
		@counts = Donor.distinct.group(:industry).count
		

	end
end

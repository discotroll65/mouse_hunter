class PoliticiansController < ApplicationController 	
	def index
	  #Data in the Politician table is currently populated/saved by running 'rake db:seed' in the terminal, which does an API call that hardwires in the reps from zipcode 12009##	
		@politicians = Politician.all
		@zipcode = params[:zipcode]
	 

		@politicians_zip = []
		
		#This goes over an array of hashes containing politicians of the passed-in zipcode and their attributes, and then creates active records of them. A validate uniqueness in the model makes sure that duplicates don't happen


		Politician.get_politicians(@zipcode).each do |politician|
			@politicians_zip << Politician.create(name: (politician["first_name"] + " " + politician["last_name"]), first_name: politician["first_name"], last_name: politician["last_name"], district: politician["district"], state: politician["state"], title: politician["title"], twitter_id: politician["twitter_id"], in_office: politician["in_office"], contact_form: politician["contact_form"], party: politician["party"], congress_cid: politician["crp_id"], chamber: politician["chamber"], bioguide_id: politician["bioguide_id"])
		end
		# @politicians = Politician.all
	end

	def show
		@politician = Politician.find(params[:id])

	end
end

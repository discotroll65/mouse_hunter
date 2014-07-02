class PoliticiansController < ApplicationController 	
	def index
		@politicians = Politician.get_politicians
		Politician.destroy_all 
		@politicians.each do |politician|
			Politician.create(name: politician["last_name"])
		end
		@politicians = Politician.all
	end

	def show
		# check the params thing....
		# @politician = Politician.find(params[:id])
	end
end

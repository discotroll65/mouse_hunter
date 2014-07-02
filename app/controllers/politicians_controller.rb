class PoliticiansController < ApplicationController 	
	def index
		@politicians = Politician.get_politicians 
		@politicians.each do |politician|
			Politician.create(name: politician["last_name"])
		end
	end

	def show
		# check the params thing....
		# @politician = Politician.find(params[:id])
	end
end

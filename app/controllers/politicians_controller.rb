class PoliticiansController < ApplicationController 	
	def index
		@politicians = Politician.get_politicians 
	end

	def show
		# check the params thing....
		@politicians = Politician.find(params[:id])
	end
end

class PoliticiansController < ApplicationController 	
	def index
	@politicians = Politician.all

	 ##Data is currently populated by running 'rake db:seed' in the terminal##
		# @politicians = Politician.get_politicians
		# Politician.destroy_all 
		# @politicians.each do |politician|
		# 	Politician.create(name: politician["last_name"])
		# end
		# @politicians = Politician.all


	end

	def show
		@politician = Politician.find(params[:id])

	end
end

class DonorsController < ApplicationController
	def index
		@donors = Donors.get_donors
	end

	def show
		@donors = Donors.find(params[:id])
	end
end
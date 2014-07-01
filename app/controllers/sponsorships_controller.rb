class SponsorshipsController < ApplicationController
	def index
		@sponsorships = Sponsorships.get_bills
	end

	def show
		@sponsorships = Sponsorships.find(params[:id])
	end
end
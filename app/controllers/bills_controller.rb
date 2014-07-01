class BillsController < ApplicationController
	def index
		@bills = Bills.get_bills
	end

	def show
		@petitions = Petitions.find(params[:id])
	end
end
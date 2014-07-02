class LobbiesController < ApplicationController
	def index
		@lobbies = Lobbies.get_lobbbies
	end

	def show
		@lobbies = Lobbies.find(params[:id])
	end
end
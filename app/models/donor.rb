class Donor < ActiveRecord::Base
	has_many :lobbies
	has_many :politicians, :through => :lobbies
end

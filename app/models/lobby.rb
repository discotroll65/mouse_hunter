class Lobby < ActiveRecord::Base
	has_many :influences
	has_many :politicians, :through => :influences
	has_many :donors

	validates_uniqueness_of :industry_code
	
end

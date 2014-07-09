class Influence < ActiveRecord::Base
	belongs_to :politician
	belongs_to :lobby
end

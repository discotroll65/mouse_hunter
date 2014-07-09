class Assignment < ActiveRecord::Base
	belongs_to :politician
	belongs_to :committee
end

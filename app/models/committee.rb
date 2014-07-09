class Committee < ActiveRecord::Base
	has_many :assignments
	has_many :politicians, :through => :assignments

	validates_uniqueness_of :committee_code
end

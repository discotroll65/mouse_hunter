class Committee < ActiveRecord::Base
	has_many :assignments
	has_many :politicians, :through => :assignments
end

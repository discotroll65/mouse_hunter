class Post < ActiveRecord::Base
	belongs_to :politician
	validates_uniqueness_of :body
end

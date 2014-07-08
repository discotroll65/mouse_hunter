class Bill < ActiveRecord::Base
	has_many :pvotes
	has_many :sponsorships
	has_many :sponsoring_politicians, :through => :sponsorships, :source => :politician
	has_many :voting_politicians, :through => :pvotes, :source => :politician
	def self.get_bills
		# get help with API reading
		response = RestClient.get("")
		parsed_response = JSON.parse(response)
		bills = parsed_response[""]
		bills
	end
	#validates_uniqueness_of :title
end

class Bill < ActiveRecord::Base
	has_many :pvotes
	has_many :sponsorships
	has_one :sponsoring_politician, :through => :sponsorship, :source => :politician
	has_many :voting_politicians, :through => :pvotes, :source => :politician
	validates_uniqueness_of :bill_id
	def self.get_bills
		# get help with API reading
		response = RestClient.get("")
		parsed_response = JSON.parse(response)
		bills = parsed_response[""]
		bills
	end
	#validates_uniqueness_of :title
end

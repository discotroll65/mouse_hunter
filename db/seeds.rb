# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


	#Gets the full response from the Sunlight Foundation 
		response = RestClient.get("http://congress.api.sunlightfoundation.com/legislators/locate?zip=12009&apikey=64177a5c45dc44eb8752332b15fb89bf")
		parsed_response = JSON.parse(response)
		politicians = parsed_response["results"]



		


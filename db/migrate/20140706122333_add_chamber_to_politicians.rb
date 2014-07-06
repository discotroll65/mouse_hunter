class AddChamberToPoliticians < ActiveRecord::Migration
  def change
  	add_column :politicians, :chamber, :string
  	add_column :politicians, :NYT_id, :string
  	add_column :politicians, :url, :string
  	add_column :politicians, :seniority, :string
  	add_column :politicians, :next_election, :string
  	add_column :politicians, :missed_votes_pct, :string
  	add_column :politicians, :votes_with_party_pct, :string
  	add_column :politicians, :facebook_account, :string
  end
end

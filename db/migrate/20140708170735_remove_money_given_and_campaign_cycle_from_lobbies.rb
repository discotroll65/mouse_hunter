class RemoveMoneyGivenAndCampaignCycleFromLobbies < ActiveRecord::Migration
  def change
  	remove_column :lobbies, :money_given, :integer
  	remove_column :lobbies, :campaign_cycle, :string
  end
end

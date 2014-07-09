class RemovePoliticianIdAndDonorIdFromLobby < ActiveRecord::Migration
  def change
  	remove_column :lobbies, :politician_id, :integer
  	remove_column :lobbies, :donor_id, :integer
  end
end

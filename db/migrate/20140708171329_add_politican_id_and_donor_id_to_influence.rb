class AddPoliticanIdAndDonorIdToInfluence < ActiveRecord::Migration
  def change
  	add_column :influences, :politician_id, :integer
  	add_column :influences, :lobby_id, :integer
  end
end

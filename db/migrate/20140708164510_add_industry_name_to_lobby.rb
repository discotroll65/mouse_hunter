class AddIndustryNameToLobby < ActiveRecord::Migration
  def change
  	add_column :lobbies, :industry_code, :string
  	add_column :lobbies, :industry_name, :string
  end
end

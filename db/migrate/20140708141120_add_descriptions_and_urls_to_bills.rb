class AddDescriptionsAndUrlsToBills < ActiveRecord::Migration
  def change
  	add_column :bills, :official_title, :string
  	add_column :bills, :url, :string
  end
end

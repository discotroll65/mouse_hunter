class AddCidToPoliticians < ActiveRecord::Migration
  def change
  	add_column :politicians, :congress_cid, :string
  end
end

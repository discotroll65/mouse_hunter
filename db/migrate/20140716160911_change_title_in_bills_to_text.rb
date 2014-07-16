class ChangeTitleInBillsToText < ActiveRecord::Migration
 def up
  	change_column :bills, :title, :text
  end

  def down
  	change_column :bills, :title, :string
  end
end

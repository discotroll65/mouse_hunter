class ChangeOfficalTitleColumnInBillsToText < ActiveRecord::Migration
  def up
  	change_column :bills, :official_title, :text
  end

  def down
  	change_column :bills, :official_title, :string
  end
end

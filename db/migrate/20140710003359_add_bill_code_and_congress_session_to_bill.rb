class AddBillCodeAndCongressSessionToBill < ActiveRecord::Migration
  def change
  	add_column :bills, :bill_id, :string
  	add_column :bills, :congress, :string
  	add_column :bills, :voted_on, :string
  end
end

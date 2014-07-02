class CreateDonors < ActiveRecord::Migration
  def change
    create_table :donors do |t|
      t.string :name
      t.string :industry
      
      t.timestamps
    end
  end
end

class CreatePvotes < ActiveRecord::Migration
  def change
    create_table :pvotes do |t|
      t.string :name
      t.string :vote
      t.integer :bill_id
      t.integer :politician_id
      t.integer :round

      t.timestamps
    end
  end
end

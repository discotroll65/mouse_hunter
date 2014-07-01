class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :title
      t.string :issue
      t.string :status

      t.timestamps
    end
  end
end

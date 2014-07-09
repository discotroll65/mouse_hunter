class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :politician_id
      t.integer :committee_id

      t.timestamps
    end
  end
end

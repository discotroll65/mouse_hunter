class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
      t.string :name
      t.string :committee_code
      t.string :is_subcommittee

      t.timestamps
    end
  end
end

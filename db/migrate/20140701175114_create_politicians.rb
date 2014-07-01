class CreatePoliticians < ActiveRecord::Migration
  def change
    create_table :politicians do |t|
      t.string :name
      t.string :profile_pic
      t.string :district
      t.string :state
      t.string :party
      t.integer :voting_attendance
      t.integer :money_raised
      t.integer :efficiency
      t.integer :sponsorship_id

      t.timestamps
    end
  end
end

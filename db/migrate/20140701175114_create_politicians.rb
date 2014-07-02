class CreatePoliticians < ActiveRecord::Migration
  def change
    create_table :politicians do |t|
      # sunlight foundation API
      # t.string :title 
      t.string :name
      # we probably want t.string :first_name
      # and t.string :last_name
      t.string :profile_pic
      t.string :district
      t.string :state
      t.string :party
      # t.string :contact_form
      # t.string :twitter_id
      # t.string :in_office
      # we will not voting attendance from sunlight
      t.integer :voting_attendance
      t.integer :money_raised
      t.integer :efficiency
      t.integer :sponsorship_id
      t.timestamps
    end
  end
end

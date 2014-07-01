class CreateSponsorships < ActiveRecord::Migration
  def change
    create_table :sponsorships do |t|
      t.integer :politician_id
      t.integer :bill_id

      t.timestamps
    end
  end
end

class CreateLobbies < ActiveRecord::Migration
  def change
    create_table :lobbies do |t|
      t.integer :politician_id
      t.integer :donor_id
      t.integer :money_given
      t.string :campaign_cycle

      t.timestamps
    end
  end
end

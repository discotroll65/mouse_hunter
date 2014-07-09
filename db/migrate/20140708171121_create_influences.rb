class CreateInfluences < ActiveRecord::Migration
  def change
    create_table :influences do |t|
      t.string :money_given
      t.string :campaign_cycle

      t.timestamps
    end
  end
end

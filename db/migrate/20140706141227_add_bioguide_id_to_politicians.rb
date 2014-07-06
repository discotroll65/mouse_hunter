class AddBioguideIdToPoliticians < ActiveRecord::Migration
  def change
  	add_column :politicians, :bioguide_id, :string
  end
end

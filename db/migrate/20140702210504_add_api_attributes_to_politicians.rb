class AddApiAttributesToPoliticians < ActiveRecord::Migration
  def change
  	add_column :politicians, :title, :string 
  	add_column :politicians, :first_name, :string
  	add_column :politicians, :last_name, :string
  	add_column :politicians, :contact_form, :string 
  	add_column :politicians, :twitter_id, :string
  	add_column :politicians, :in_office, :string
  end
end
      
 
      

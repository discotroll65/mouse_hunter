class AddIssueToPvote < ActiveRecord::Migration
  def change
  	add_column :pvotes, :issue, :string
  end
end

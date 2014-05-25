class ChangeEventUserToAssociation < ActiveRecord::Migration
  def change
    remove_column :events, :user, :text
    add_column :events, :user_id, :integer
    add_index :events, :user_id
  end
end

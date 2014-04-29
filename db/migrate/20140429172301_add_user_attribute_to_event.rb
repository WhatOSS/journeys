class AddUserAttributeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :user, :text
  end
end

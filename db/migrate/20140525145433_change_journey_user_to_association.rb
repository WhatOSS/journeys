class ChangeJourneyUserToAssociation < ActiveRecord::Migration
  def change
    remove_column :journeys, :user, :text
    add_column :journeys, :user_id, :integer
    add_index :journeys, :user_id
  end
end

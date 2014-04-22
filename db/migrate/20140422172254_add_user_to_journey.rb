class AddUserToJourney < ActiveRecord::Migration
  def change
    add_column :journeys, :user, :text
  end
end

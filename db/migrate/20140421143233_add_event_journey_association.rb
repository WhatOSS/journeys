class AddEventJourneyAssociation < ActiveRecord::Migration
  def change
    add_column :events, :journey_id, :integer
    add_index :events, :journey_id
  end
end

class CreateJourneys < ActiveRecord::Migration
  def change
    create_table :journeys do |t|

      t.timestamps
    end
  end
end

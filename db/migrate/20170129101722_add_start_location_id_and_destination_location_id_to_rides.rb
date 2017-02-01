class AddStartLocationIdAndDestinationLocationIdToRides < ActiveRecord::Migration[5.0]
  def change
    add_column :rides, :start_location_id, :integer
    add_column :rides, :destination_location_id, :integer
  end
end

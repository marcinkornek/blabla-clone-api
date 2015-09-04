class AddRequestedPlacesToRides < ActiveRecord::Migration
  def change
    add_column :rides, :requested_places, :integer, default: 0
  end
end

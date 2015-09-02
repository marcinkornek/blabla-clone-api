class AddPlacesToRideRequests < ActiveRecord::Migration
  def change
    add_column :ride_requests, :places, :integer
  end
end

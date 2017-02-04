class AddIndexToRideRequests < ActiveRecord::Migration[5.0]
  def change
    add_index :ride_requests, [:passenger_id, :ride_id], unique: true
  end
end

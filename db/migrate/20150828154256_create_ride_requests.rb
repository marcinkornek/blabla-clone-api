class CreateRideRequests < ActiveRecord::Migration
  def change
    create_table :ride_requests do |t|
      t.integer :passenger_id
      t.integer :ride_id
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end

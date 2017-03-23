class RemoveRideColumns < ActiveRecord::Migration[5.0]
  def up
    remove_column :rides, :start_city
    remove_column :rides, :start_city_lat
    remove_column :rides, :start_city_lng
    remove_column :rides, :destination_city
    remove_column :rides, :destination_city_lat
    remove_column :rides, :destination_city_lng
  end

  def down
    add_column :rides, :start_city, :string
    add_column :rides, :start_city_lat, :string
    add_column :rides, :start_city_lng, :string
    add_column :rides, :destination_city, :string
    add_column :rides, :destination_city_lat, :string
    add_column :rides, :destination_city_lng, :string
  end
end

class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string :start_city
      t.string :start_city_lat
      t.string :start_city_lng
      t.string :destination_city
      t.string :destination_city_lat
      t.string :destination_city_lng
      t.integer :driver_id
      t.integer :seats
      t.datetime :start_date
      t.decimal :price
      t.integer :car_id

      t.timestamps null: false
    end
  end
end

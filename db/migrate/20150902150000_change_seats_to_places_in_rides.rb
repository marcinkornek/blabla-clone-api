class ChangeSeatsToPlacesInRides < ActiveRecord::Migration
  def change
    rename_column :rides, :seats, :places
  end
end

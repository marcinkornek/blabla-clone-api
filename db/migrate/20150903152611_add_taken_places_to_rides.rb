class AddTakenPlacesToRides < ActiveRecord::Migration
  def change
    add_column :rides, :taken_places, :integer, default: 0
  end
end

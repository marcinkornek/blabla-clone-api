class AddCarPhotoToCars < ActiveRecord::Migration
  def change
    add_column :cars, :car_photo, :string
  end
end

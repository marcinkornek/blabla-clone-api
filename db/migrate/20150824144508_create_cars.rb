class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :brand
      t.string :model
      t.string :production_year
      t.integer :comfort
      t.integer :places
      t.integer :color
      t.integer :category
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

ActiveAdmin.register Car do
  index do
    selectable_column
    id_column
    column :user
    column :brand
    column :model
    column :production_year
    column :comfort
    column :color
    column :category
    column :created_at
    actions
  end

  filter :id
  filter :user_id
  filter :brand, as: :select, collection: proc { Car.pluck(:brand).uniq.sort.compact }
  filter :model
  filter :production_year
  filter :comfort, as: :select, collection: proc { Car.comforts }
  filter :color, as: :select, collection: proc { Car.colors }
  filter :category, as: :select, collection: proc { Car.categories }
  filter :created_at
end

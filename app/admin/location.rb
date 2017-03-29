# frozen_string_literal: true

ActiveAdmin.register Location do
  scope :all, default: true

  filter :id
  filter :country,
         as: :select,
         collection: proc { Location.uniq.order(:country).pluck(:country).compact }
  filter :address
  filter :latitude
  filter :longitude
  filter :created_at

  index do
    selectable_column
    id_column
    column :country
    column :address
    column :latitude
    column :longitude
    column :created_at
    actions
  end
end

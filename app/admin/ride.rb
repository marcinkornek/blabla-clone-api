# frozen_string_literal: true
ActiveAdmin.register Ride do
  scope :all, default: true

  filter :id
  filter :driver_id
  filter :start_location_id
  filter :destination_location_id
  filter :price
  filter :currency
  filter :places
  filter :created_at

  index do
    selectable_column
    id_column
    column :driver
    column :start_location do |ride|
      link_to ride.start_location.address, admin_location_path(ride.start_location_id)
    end
    column :destination_location do |ride|
      link_to ride.destination_location.address, admin_location_path(ride.destination_location_id)
    end
    column :ride_start_date do |ride|
      ride.start_date.strftime("%Y.%m.%d %H:%M")
    end
    column :car
    column :price
    column :currency
    column :places
    column :requested_places
    column :taken_places
    column :created_at
    actions
  end
end

# frozen_string_literal: true

ActiveAdmin.register RideRequest do
  scope :all, default: true

  filter :id
  filter :passenger_id
  filter :ride_driver_id_equals, as: :string, label: "ride driver_id"
  filter :ride_id
  filter :places
  filter :status, as: :select, collection: proc { RideRequest.statuses }
  filter :created_at

  index do
    selectable_column
    id_column
    column :ride do |ride_request|
      link_to ride_request.ride.locations_formatted_shortened,
              admin_ride_path(ride_request.ride_id)
    end
    column :ride_start_date do |ride_request|
      ride_request.ride.start_date.strftime("%Y.%m.%d %H:%M")
    end
    column :author do |ride_request|
      ride_request.ride&.driver
    end
    column :passenger
    column :places
    column :status
    column :created_at
    actions
  end
end

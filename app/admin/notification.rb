# frozen_string_literal: true
ActiveAdmin.register Notification do
  scope :all, default: true

  filter :id
  filter :sender_id
  filter :receiver_id
  filter :ride_id
  filter :ride_request_id
  filter :notification_type, as: :select, collection: proc { Notification::NOTIFICATION_TYPES }
  filter :seen_at
  filter :created_at

  index do
    selectable_column
    id_column
    column :sender
    column :receiver
    column :ride do |notification|
      link_to notification.ride.locations_formatted_shortened,
              admin_ride_path(notification.ride_id)
    end
    column :ride_request do |notification|
      link_to notification.ride_request_id, admin_ride_request_path(notification.ride_request_id)
    end
    column :notification_type
    column :seen_at
    column :created_at
    actions
  end
end

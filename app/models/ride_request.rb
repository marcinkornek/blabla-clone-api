class RideRequest < ActiveRecord::Base
  belongs_to :passenger, class_name: "User"
  belongs_to :ride
  has_many :notifications

  enum status:  { rejected: -1, pending: 0, accepted: 1 }

  counter_culture :ride, column_name: Proc.new {|model| model.accepted? ? "taken_places" : nil }, delta_column: "places"
  counter_culture :ride, column_name: Proc.new {|model| model.pending? ? "requested_places" : nil }, delta_column: "places"

  after_create :create_ride_request_notification
  after_update :change_ride_request_status_notification

  private

  def create_ride_request_notification
    create_notification_to_driver("ride_request_created")
  end

  def change_ride_request_status_notification
    case status
    when "accepted"
      create_notification_to_passenger("ride_request_accepted")
    when "rejected"
      create_notification_to_passenger("ride_request_rejected")
    end
  end

  def create_notification_to_driver(notification_type)
    self.notifications.create(ride: ride, sender: passenger, receiver: ride.driver,
      notification_type: notification_type)
  end

  def create_notification_to_passenger(notification_type)
    self.notifications.create(ride: ride, sender: ride.driver, receiver: passenger,
      notification_type: notification_type)
  end
end

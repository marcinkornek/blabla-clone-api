# frozen_string_literal: true
class RideRequest < ApplicationRecord
  belongs_to :passenger, class_name: "User"
  belongs_to :ride
  has_many :notifications

  validates :passenger, presence: true
  validates :ride, presence: true
  validates :places, presence: true, numericality: { greater_than: 0 }
  validates :ride_id, uniqueness: { scope: :passenger_id }

  enum status: { rejected: -1, pending: 0, accepted: 1 }

  counter_culture :ride, column_name: Proc.new { |model|
    model.accepted? ? "taken_places" : nil
  }, delta_column: "places"
  counter_culture :ride, column_name: Proc.new { |model|
    model.pending? ? "requested_places" : nil
  }, delta_column: "places"

  after_create :create_ride_request_notification
  after_update :change_ride_request_status_notification

  private

  def create_ride_request_notification
    Notifier.new(
      "ride_request_created",
      passenger,
      ride.driver,
      ride: ride, ride_request: self, broadcast: true,
    ).call
  end

  def change_ride_request_status_notification
    case status
    when "accepted"
      Notifier.new(
        "ride_request_accepted",
        ride.driver, passenger,
        ride: ride, ride_request: self, broadcast: true
      ).call
    when "rejected"
      Notifier.new(
        "ride_request_rejected",
        ride.driver, passenger,
        ride: ride, ride_request: self, broadcast: true
      ).call
    end
  end
end

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

  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :rejected, -> { where(status: 'rejected') }

  private

  def create_ride_request_notification
    options = {
      ride: ride,
      ride_request: self,
      broadcast: true,
    }
    NotificationCreator.new(
      notification_type: "ride_request_created",
      sender_id: passenger_id,
      receiver_id: ride.driver_id,
      options: options,
    ).call
  end

  def change_ride_request_status_notification
    options = {
      ride: ride,
      ride_request: self,
      broadcast: true,
    }
    NotificationCreator.new(
      notification_type: status == "accepted" ? "ride_request_created" : "ride_request_rejected",
      sender_id: ride.driver_id,
      receiver_id: passenger_id,
      options: options,
    ).call
  end
end

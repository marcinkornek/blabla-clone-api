# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :ride
  belongs_to :ride_request

  NOTIFICATION_TYPES = %w(ride_request_created ride_request_accepted ride_request_rejected).freeze

  validates :notification_type,
            presence: true,
            inclusion: {
              in: NOTIFICATION_TYPES,
              message: "%{value} is not a valid notification_type",
            }
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :ride_id, presence: true

  after_create :notify_users

  scope :unread, -> { where(seen_at: nil) }

  def mark_as_seen!
    update(seen_at: Time.current)
  end

  def notify_users
    Notifier.new(self).call
  end

  def mobile_heading
    case notification_type
    when "ride_request_created"
      "New ride request"
    when "ride_request_accepted"
      "Ride request accepted"
    when "ride_request_rejected"
      "Ride request rejected"
    end
  end

  def mobile_body
    case notification_type
    when "ride_request_created"
      "#{sender.full_name} added ride request for your ride #{ride.locations_formatted}"
    when "ride_request_accepted"
      "#{sender.full_name} accepted your ride request in ride #{ride.locations_formatted}"
    when "ride_request_rejected"
      "#{sender.full_name} rejected your ride request in ride #{ride.locations_formatted}"
    end
  end
end

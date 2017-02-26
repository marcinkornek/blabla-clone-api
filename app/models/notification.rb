# frozen_string_literal: true
class Notification < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :ride
  belongs_to :ride_request

  NOTIFICATION_TYPES = %w(ride_request_created ride_request_accepted ride_request_rejected).freeze

  validates :notification_type, presence: true,
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
end

# frozen_string_literal: true
class NotificationCreator
  attr_reader :notification_type, :sender_id, :receiver_id, :options

  def initialize(notification_type:, sender_id:, receiver_id:, options:)
    @notification_type = notification_type
    @sender_id = sender_id
    @receiver_id = receiver_id
    @options = options
  end

  def call
    create_notification
  end

  private

  def create_notification
    Notification.create(
      notification_type: notification_type,
      sender_id: sender_id,
      receiver_id: receiver_id,
      ride: options[:ride].presence,
      ride_request: options[:ride_request].presence,
    )
  end
end

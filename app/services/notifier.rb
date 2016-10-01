class Notifier
  attr_reader :notification_type, :sender, :receivers, :options

  def initialize(notification_type, sender, receivers, options = {})
    @notification_type = notification_type
    @sender = sender
    @receivers = receivers
    @options = options
  end

  def call
    notify_all(notification_type, sender, receivers, options)
  end

  private

  def notify_all(notification_type, sender, receivers, options = {})
    if receivers.class == Array
      receivers.each { |receiver| notify(notification_type, sender, receiver, options) }
    else
      notify(notification_type, sender, receivers, options)
    end
  end

  def notify(notification_type, sender, receiver, options = {})
    notification = Notification.create(
      notification_type: notification_type,
      sender: sender,
      receiver: receiver,
      ride: options[:ride],
      ride_request: options[:ride_request]
    )
    broadcast(notification) if options[:broadcast]
  end

  def broadcast(notification)
    ActionCable.server.broadcast(
      "notifications:#{notification.receiver.id}",
      notification: API::V1::Entities::NotificationWithUnreadCount.represent(
        notification,
        current_user: notification.receiver
      )
    )
  end
end

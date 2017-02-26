# frozen_string_literal: true
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
      ride_request: options[:ride_request],
    )
    notify_web(notification) if options[:broadcast]
    notify_mobile(notification)
  end

  def notify_mobile(notification)
    player_id = notification.receiver.player_id
    return if player_id.nil?
    params = {
      app_id: ENV["APP_ID"],
      include_player_ids: [player_id],
      contents: {
        en: "Hello!",
      },
    }
    send_mobile_notification(params)
  end

  def send_mobile_notification(params)
    response = OneSignal::Notification.create(params: params)
    response["status"]
  rescue OneSignal::OneSignalError => e
    e.http_status
  end

  def notify_web(notification)
    ActionCable.server.broadcast(
      "notifications:#{notification.receiver.id}",
      notification: NotificationSerializer.new(notification, current_user: notification.receiver),
    )
  end
end

# frozen_string_literal: true

class Notifier
  class MobileNotifier
    attr_reader :notification, :options

    def initialize(notification, options = {})
      @notification = notification
      @options = options
    end

    def call
      notify
    end

    private

    def notify
      player_id = notification.receiver.player_id
      return if player_id.nil?
      params = {
        app_id: ENV["APP_ID"],
        include_player_ids: [player_id],
        headings: {
          en: notification.mobile_heading,
        },
        contents: {
          en: notification.mobile_body,
        },
        data: NotificationSerializer.new(notification).as_json,
      }
      send_mobile_notification(params)
    end

    def send_mobile_notification(params)
      response = OneSignal::Notification.create(params: params)
      response["status"]
    rescue OneSignal::OneSignalError => e
      e.http_status
    end
  end
end

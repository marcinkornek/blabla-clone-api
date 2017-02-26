# frozen_string_literal: true
class Notifier
  class ActioncableNotifier
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
      ActionCable.server.broadcast(
        "notifications:#{notification.receiver.id}",
        notification: NotificationSerializer.new(notification, current_user: notification.receiver),
      )
    end
  end
end

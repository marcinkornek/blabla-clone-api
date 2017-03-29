# frozen_string_literal: true

class Notifier
  attr_reader :notification, :options

  def initialize(notification, options = {})
    @notification = notification
    @options = options
  end

  def call
    enabled_notifications.each do |notification|
      send("notify_#{notification}")
    end
  end

  private

  def notify_actioncable
    Notifier::ActioncableNotifier.new(notification, options).call
  end

  def notify_mobile
    Notifier::MobileNotifier.new(notification, options).call
  end

  def enabled_notifications
    %w(actioncable mobile)
  end
end

# frozen_string_literal: true
class NotificationWithUnreadSerializer < ActiveModel::Serializer
  attributes :id, :ride_request_id, :notification_type, :seen_at, :created_at, :unread_count

  has_one :sender, serializer: UserSerializer
  has_one :receiver, serializer: UserSerializer
  has_one :ride, serializer: RideSerializer

  def unread_count
    return unless scope.current_user
    scope.current_user.notifications.unread.count
  end
end

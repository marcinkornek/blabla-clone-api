# frozen_string_literal: true
class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :ride_request_id, :notification_type, :seen_at, :created_at

  has_one :sender, serializer: UserSerializer
  has_one :receiver, serializer: UserSerializer
  has_one :ride, serializer: RideSerializer
end

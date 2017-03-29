# frozen_string_literal: true

class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :ride_request_id, :notification_type, :seen_at, :created_at

  has_one :sender, serializer: UserSimpleSerializer
  has_one :receiver, serializer: UserSimpleSerializer
  has_one :ride, serializer: RideSimpleSerializer
end

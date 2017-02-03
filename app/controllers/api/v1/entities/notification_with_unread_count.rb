# frozen_string_literal: true
module API
  module V1
    module Entities
      class NotificationWithUnreadCount < Grape::Entity
        expose :id
        expose :ride_request_id
        expose :notification_type
        expose :seen_at
        expose :created_at
        expose :sender, using: Entities::UserSimple
        expose :receiver, using: Entities::UserSimple
        expose :ride, using: Entities::RideSimple
        expose :unread_count

        def unread_count
          options[:current_user].notifications.unread.count
        end
      end
    end
  end
end

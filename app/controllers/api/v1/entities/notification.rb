module API
  module V1
    module Entities
      class Notification < Grape::Entity
        expose :id
        expose :ride_request_id
        expose :notification_type
        expose :seen_at
        expose :created_at
        expose :sender, using: Entities::UserSimple
        expose :receiver, using: Entities::UserSimple
        expose :ride, using: Entities::RideSimple
      end
    end
  end
end

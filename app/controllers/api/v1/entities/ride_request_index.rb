module API
  module V1
    module Entities
      class RideRequestIndex < Grape::Entity
        expose :id
        expose :status
        expose :places
        expose :created_at
        expose :updated_at
        expose :passenger, using: Entities::UserSimple
      end
    end
  end
end

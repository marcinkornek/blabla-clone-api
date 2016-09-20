module API
  module V1
    module Entities
      class RideRequestSimple < Grape::Entity
        expose :id
        expose :status
        expose :places
        expose :created_at
        expose :updated_at
      end
    end
  end
end

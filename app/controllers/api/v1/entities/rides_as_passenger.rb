module API
  module V1
    module Entities
      class RidesAsPassenger < Grape::Entity
        present_collection true
        expose :items, as: 'rides', using: Entities::RideAsPassenger

        expose :meta

        private

        def meta
          options[:pagination]
        end
      end
    end
  end
end

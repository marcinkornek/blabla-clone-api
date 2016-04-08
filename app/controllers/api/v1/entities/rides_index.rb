module API
  module V1
    module Entities
      class RidesIndex < Grape::Entity
        present_collection true
        expose :items, as: 'rides', using: Entities::RideIndex

        expose :meta

        private

        def meta
          options[:pagination]
        end
      end
    end
  end
end

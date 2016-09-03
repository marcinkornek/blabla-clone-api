module API
  module V1
    module Entities
      class RidesIndex < Grape::Entity
        present_collection true
        expose :items, as: 'items', using: Entities::RideIndex

        expose :meta
        expose :filters

        private

        def meta
          options[:pagination]
        end

        def filters
          options[:filters]
        end
      end
    end
  end
end

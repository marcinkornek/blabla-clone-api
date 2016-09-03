module API
  module V1
    module Entities
      class RidesAsDriver < Grape::Entity
        present_collection true
        expose :items, as: 'items', using: Entities::RideAsDriver

        expose :meta

        private

        def meta
          options[:pagination]
        end
      end
    end
  end
end

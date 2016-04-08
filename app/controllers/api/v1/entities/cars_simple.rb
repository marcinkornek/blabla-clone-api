module API
  module V1
    module Entities
      class CarsSimple < Grape::Entity
        present_collection true
        expose :items, as: 'user', using: Entities::CarSimple

        expose :meta

        private

        def meta
          options[:pagination]
        end
      end
    end
  end
end

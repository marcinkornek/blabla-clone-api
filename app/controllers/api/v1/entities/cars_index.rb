module API
  module V1
    module Entities
      class CarsIndex < Grape::Entity
        present_collection true
        expose :items, as: 'cars', using: Entities::CarIndex

        expose :meta

        private

        def meta
          options[:pagination]
        end
      end
    end
  end
end

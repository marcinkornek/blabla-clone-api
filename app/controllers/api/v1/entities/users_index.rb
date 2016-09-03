module API
  module V1
    module Entities
      class UsersIndex < Grape::Entity
        present_collection true
        expose :items, as: 'items', using: Entities::UserIndex

        expose :meta

        private

        def meta
          options[:pagination]
        end
      end
    end
  end
end

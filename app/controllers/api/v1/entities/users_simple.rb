module API
  module V1
    module Entities
      class UsersSimple < Grape::Entity
        present_collection true
        expose :items, as: 'items', using: Entities::UserSimple

        expose :meta

        private

        def meta
          options[:pagination]
        end
      end
    end
  end
end

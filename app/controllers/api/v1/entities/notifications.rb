module API
  module V1
    module Entities
      class Notifications < Grape::Entity
        present_collection true
        expose :items, as: 'items', using: Entities::Notification

        expose :meta

        private

        def meta
          options[:pagination]
        end
      end
    end
  end
end

# frozen_string_literal: true
module API
  module V1
    module Entities
      class RideRequestsIndex < Grape::Entity
        present_collection true
        expose :items, as: "items", using: Entities::RideRequestIndex

        expose :meta

        private

        def meta
          options[:pagination]
        end
      end
    end
  end
end

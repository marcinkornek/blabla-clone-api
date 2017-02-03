# frozen_string_literal: true
module API
  module V1
    module Entities
      class RideAsDriver < Grape::Entity
        expose :id
        expose :start_location
        expose :destination_location
        expose :free_places_count
        expose :places
        expose :places_full
        expose :start_date
        expose :price
        expose :currency
        expose :car, using: Entities::CarSimple

        def start_location
          object.start_location.address
        end

        def destination_location
          object.destination_location.address
        end
      end
    end
  end
end

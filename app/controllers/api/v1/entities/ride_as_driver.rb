module API
  module V1
    module Entities
      class RideAsDriver < Grape::Entity
        expose :id
        expose :start_city
        expose :destination_city
        expose :free_places_count
        expose :places
        expose :places_full
        expose :start_date
        expose :price
        expose :currency
        expose :car, using: Entities::CarSimple
      end
    end
  end
end

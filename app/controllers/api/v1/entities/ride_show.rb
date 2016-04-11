module API
  module V1
    module Entities
      class RideShow < Grape::Entity
        expose :id
        expose :start_city
        expose :start_city_lat
        expose :start_city_lng
        expose :destination_city
        expose :destination_city_lat
        expose :destination_city_lng
        expose :free_places_count
        expose :places
        expose :places_full
        expose :start_date
        expose :price
        expose :currency
        expose :created_at
        expose :updated_at
        expose :driver, using: Entities::UserIndex
        expose :car, using: Entities::CarSimple
      end
    end
  end
end

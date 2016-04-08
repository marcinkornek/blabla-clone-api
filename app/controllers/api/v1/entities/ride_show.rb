module API
  module V1
    module Entities
      class RideShow < Grape::Entity
        espose :id
        espose :start_city
        espose :start_city_lat
        espose :start_city_lng
        espose :destination_city
        espose :destination_city_lat
        espose :destination_city_lng
        espose :free_places_count
        espose :places
        espose :places_full
        espose :start_date
        espose :price
        espose :currency
        espose :created_at
        espose :updated_at
        expose :driver, using: Entities::UserIndex
        expose :car, using: Entities::CarSimple
      end
    end
  end
end

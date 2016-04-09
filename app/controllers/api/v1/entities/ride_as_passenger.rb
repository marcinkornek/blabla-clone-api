module API
  module V1
    module Entities
      class RideAsPassenger < Grape::Entity
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
        expose :driver, using: Entities::UserIndex
        expose :status

        def id
          object.ride.id
        end

        def start_city
          object.ride.start_city
        end

        def destination_city
          object.ride.destination_city
        end

        def free_places_count
          object.ride.free_places_count
        end

        def places
          object.ride.places
        end

        def places_full
          object.ride.places_full
        end

        def start_date
          object.ride.start_date
        end

        def price
          object.ride.price
        end

        def currency
          object.ride.currency
        end

        def driver
          object.ride.driver
        end

        def car
          object.ride.car
        end
      end
    end
  end
end
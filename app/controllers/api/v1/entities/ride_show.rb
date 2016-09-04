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
        expose :user_ride_request, using: Entities::RideRequestShow, if: lambda { |object, options| options[:current_user] && object.user_requested?(options[:current_user]) }
        expose :requested, if: lambda { |object, options| options[:current_user] }

        def user_ride_request
          object.user_ride_request(options[:current_user])
        end

        def requested
          object.user_requested?(options[:current_user])
        end
      end
    end
  end
end

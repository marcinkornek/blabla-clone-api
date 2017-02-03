# frozen_string_literal: true
module API
  module V1
    module Entities
      class RideShow < Grape::Entity
        expose :id
        expose :start_location_address
        expose :start_location_latitude
        expose :start_location_longitude
        expose :destination_location_address
        expose :destination_location_latitude
        expose :destination_location_longitude
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
        expose :car_id
        expose :user_ride_request, using: Entities::RideRequestShow, if: lambda { |object, options| options[:current_user] && object.user_requested?(options[:current_user]) }
        expose :requested, if: lambda { |_object, options| options[:current_user] }

        def user_ride_request
          object.user_ride_request(options[:current_user])
        end

        def requested
          object.user_requested?(options[:current_user])
        end

        def start_location_address
          object.start_location.address
        end

        def start_location_latitude
          object.start_location.latitude
        end

        def start_location_longitude
          object.start_location.longitude
        end

        def destination_location_address
          object.destination_location.address
        end

        def destination_location_latitude
          object.destination_location.latitude
        end

        def destination_location_longitude
          object.destination_location.longitude
        end
      end
    end
  end
end

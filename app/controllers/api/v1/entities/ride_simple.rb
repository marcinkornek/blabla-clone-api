module API
  module V1
    module Entities
      class RideSimple < Grape::Entity
        expose :id
        expose :start_location
        expose :destination_location
        expose :start_date
        expose :price
        expose :currency

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

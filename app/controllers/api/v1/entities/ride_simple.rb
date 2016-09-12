module API
  module V1
    module Entities
      class RideSimple < Grape::Entity
        expose :id
        expose :start_city
        expose :destination_city
        expose :start_date
        expose :price
        expose :currency
      end
    end
  end
end

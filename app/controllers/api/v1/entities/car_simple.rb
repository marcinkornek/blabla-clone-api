module API
  module V1
    module Entities
      class CarSimple < Grape::Entity
        expose :id
        expose :full_name
        expose :comfort
        expose :comfort_stars
        expose :places_full
        expose :owner_id
        expose :car_photo

        def full_name
          object.full_name.upcase
        end

        def places_full
          object.places.to_s + ' ' + 'place'.pluralize(object.places)
        end

        def owner_id
          object.user_id
        end

        def car_photo
          object.car_photo.mini.url || 'https://s3-eu-west-1.amazonaws.com/blabla-clone-app/uploads/car/car_photo/placeholder/car_placeholder_thumb.jpg'
        end
      end
    end
  end
end

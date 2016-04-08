module API
  module V1
    module Entities
      class CarIndex < Grape::Entity
        expose :id
        expose :brand
        expose :model
        expose :full_name
        expose :production_year
        expose :comfort
        expose :comfort_stars
        expose :places
        expose :places_full
        expose :color
        expose :comfort
        expose :category
        expose :created_at
        expose :owner_id
        expose :car_photo

        def brand
          object.brand.upcase
        end

        def model
          object.model.upcase
        end

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


require 'roar/json'

module CarIndexRepresenter
  include Roar::JSON

  property :id
  property :brand
  property :model
  property :full_name
  property :production_year
  property :comfort
  property :comfort_stars
  property :places
  property :places_full
  property :color
  property :comfort
  property :category
  property :created_at
  property :owner_id
  property :car_photo

  def brand
    super.upcase
  end

  def model
    super.upcase
  end

  def full_name
    super.upcase
  end

  def places_full
    places.to_s + ' ' + 'place'.pluralize(places)
  end

  def owner_id
    user_id
  end

  def car_photo
    super.mini.url || 'https://s3-eu-west-1.amazonaws.com/blabla-clone-app/uploads/car/car_photo/placeholder/car_placeholder_thumb.jpg'
  end
end

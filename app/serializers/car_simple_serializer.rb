# frozen_string_literal: true
class CarSimpleSerializer < ActiveModel::Serializer
  attributes :id, :brand, :model, :full_name, :production_year, :comfort,
             :comfort_stars, :places, :places_full, :color, :comfort,
             :category, :created_at, :owner_id, :car_photo

  def car_photo
    object.photo_mini_url
  end

  def owner_id
    object.user_id
  end

  def places_full
    object.places.to_s + " " + "place".pluralize(object.places)
  end
end

# frozen_string_literal: true
# rubocop:disable Style/AlignParameters
class CarSimpleSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :comfort, :comfort_stars, :places_full, :owner_id,
             :car_photo, :production_year,

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

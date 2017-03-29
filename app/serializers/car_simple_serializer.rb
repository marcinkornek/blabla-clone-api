# frozen_string_literal: true

class CarSimpleSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :places, :car_photo

  def car_photo
    object.photo_mini_url
  end
end

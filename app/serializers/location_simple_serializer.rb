# frozen_string_literal: true

class LocationSimpleSerializer < ActiveModel::Serializer
  attributes :id, :address, :latitude, :longitude
end

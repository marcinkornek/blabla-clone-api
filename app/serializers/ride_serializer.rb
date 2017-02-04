# frozen_string_literal: true
class RideSerializer < ActiveModel::Serializer
  attributes :id, :free_places_count, :places, :places_full, :start_date,
             :price, :currency, :car_id

  has_one :driver, serializer: UserSerializer
  has_one :start_location, serializer: LocationSimpleSerializer
  has_one :destination_location, serializer: LocationSimpleSerializer
  has_one :car, serializer: CarSerializer
end

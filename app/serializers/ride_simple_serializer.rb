# frozen_string_literal: true
class RideSimpleSerializer < ActiveModel::Serializer
  attributes :id, :free_places_count, :places, :places_full, :start_date,
             :price, :currency, :car_id, :driver_id, :start_location_address,
             :destination_location_address

  def start_location_address
    object.start_location&.address
  end

  def destination_location_address
    object.destination_location&.address
  end
end

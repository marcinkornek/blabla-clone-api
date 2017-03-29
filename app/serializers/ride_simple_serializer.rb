# frozen_string_literal: true

class RideSimpleSerializer < ActiveModel::Serializer
  attributes :id, :car_id, :driver_id, :start_location_id, :destination_location_id,
             :start_location_address, :destination_location_address,
             :free_places_count, :places, :places_full, :start_date,
             :price, :currency

  def start_location_address
    object.start_location&.address
  end

  def destination_location_address
    object.destination_location&.address
  end
end

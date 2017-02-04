# frozen_string_literal: true
class RideShowSerializer < ActiveModel::Serializer
  attributes :id, :free_places_count, :places, :places_full, :start_date,
             :price, :currency, :car_id, :created_at, :updated_at,
             :user_ride_request, :ride_requests

  has_one :driver, serializer: UserSimpleSerializer
  has_one :start_location, serializer: LocationSimpleSerializer
  has_one :destination_location, serializer: LocationSimpleSerializer
  has_one :car, serializer: CarSimpleSerializer

  def user_ride_request
    object.ride_requests.find_by(passenger_id: scope.current_user.id)
  end

  def ride_requests
    return [] unless scope.current_user.id == object.driver_id
    ActiveModel::Serializer::CollectionSerializer.new(
      object.ride_requests.order(:created_at),
      serializer: RideRequestSerializer,
    )
  end
end

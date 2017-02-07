# frozen_string_literal: true
class RideShowSerializer < ActiveModel::Serializer
  attributes :id, :free_places_count, :places, :places_full, :start_date,
             :price, :currency, :car_id, :created_at, :updated_at,
             :user_ride_request, :ride_requests, :requested_places_count, :user_role,
             :user_ride_request_status

  has_one :driver, serializer: UserSerializer
  has_one :start_location, serializer: LocationSimpleSerializer
  has_one :destination_location, serializer: LocationSimpleSerializer
  has_one :car, serializer: CarSerializer

  def user_role
    return unless scope&.current_user
    object.user_role(scope.current_user)
  end

  def user_ride_request_status
    return unless scope&.current_user
    object.user_ride_request_status(scope.current_user)
  end

  def user_ride_request
    return unless scope&.current_user
    object.ride_requests.find_by(passenger_id: scope&.current_user&.id)
  end

  def requested_places_count
    return unless scope&.current_user&.id == object.driver_id
    object.requested_places
  end

  def ride_requests
    return [] unless scope&.current_user&.id == object.driver_id
    ActiveModel::Serializer::CollectionSerializer.new(
      object.ride_requests.order(:created_at),
      serializer: RideRequestSerializer,
    )
  end
end

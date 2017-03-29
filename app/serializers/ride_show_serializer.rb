# frozen_string_literal: true

class RideShowSerializer < ActiveModel::Serializer
  attributes :id, :car_id, :driver_id, :start_location_id, :destination_location_id,
             :start_location_address, :destination_location_address,
             :free_places_count, :places, :places_full, :start_date,
             :price, :currency, :created_at, :updated_at,
             :user_ride_request, :ride_requests, :ride_requests_pending_count,
             :requested_places_count, :user_role, :user_ride_request_status

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

  def ride_requests_pending_count
    return nil unless scope&.current_user&.id == object.driver_id
    object.ride_requests.pending.count
  end

  def start_location_address
    object.start_location&.address
  end

  def destination_location_address
    object.destination_location&.address
  end
end

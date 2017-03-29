# frozen_string_literal: true

class RideRequestPolicy
  attr_reader :user, :ride_request

  def initialize(user, ride_request)
    @user = user
    @ride_request = ride_request
  end

  def update?
    ride_request.present? && ride_driver?
  end

  private

  def ride_driver?
    ride_request.ride.driver == user
  end
end

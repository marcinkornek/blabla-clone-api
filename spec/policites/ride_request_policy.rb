# frozen_string_literal: true

class RideRequestPolicy
  attr_reader :user, :ride_request

  def initialize(user, ride_request)
    @user = user
    @ride_request = ride_request
  end

  def create?
    user.present? && !ride_creator? && ride_requested?
  end

  def update?
    ride_creator?
  end

  def delete?
    ride_request_creator?
  end

  private

  def ride_creator?
    ride_request.ride.user == user
  end

  def ride_request_creator?
    ride_request.user == user
  end

  def ride_requested?
    ride_request.ride.user_requested?(user)
  end
end

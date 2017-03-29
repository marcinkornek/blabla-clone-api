# frozen_string_literal: true

class RidePolicy
  attr_reader :user, :ride

  def initialize(user, ride)
    @user = user
    @ride = ride
  end

  def create?
    user.present?
  end

  def update?
    (user.present? && ride.present?) && (user.admin? || ride_driver?)
  end

  def show_rides_as_driver?
    user.present?
  end

  def show_rides_as_passenger?
    user.present?
  end

  def create_ride_request?
    user.present? && ride.present? && !ride_driver? && !ride_requested?
  end

  private

  def ride_driver?
    ride.driver == user
  end

  def ride_requested?
    ride.user_requested?(user)
  end
end

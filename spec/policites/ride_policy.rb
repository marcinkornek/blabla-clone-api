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
    user.admin? || ride_driver?
  end

  def delete?
    user_admin? || ride_driver?
  end

  private

  def ride_driver?
    ride.driver == user
  end
end

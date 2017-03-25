# frozen_string_literal: true
class RideCreator
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    return unless user
    create_ride
  end

  private

  def create_ride
    ride = user.rides_as_driver.create(ride_params)
    ride
  end

  def ride_params
    {
      start_location: start_location,
      destination_location: destination_location,
      driver_id: params[:driver_id],
      car_id: params[:car_id],
      currency: params[:currency],
      places: params[:places],
      price: params[:price],
      start_date: start_date,
    }
  end

  def start_date
    params[:start_date].to_datetime if params[:start_date].present?
  end

  def start_location
    Location.find_or_create_by(
      latitude: params[:start_location_latitude],
      longitude: params[:start_location_longitude],
    ) do |location|
      location.address = params[:start_location_address]
      location.country = params[:start_location_country]
    end
  end

  def destination_location
    Location.find_or_create_by(
      latitude: params[:destination_location_latitude],
      longitude: params[:destination_location_longitude],
    ) do |location|
      location.address = params[:destination_location_address]
      location.country = params[:destination_location_country]
    end
  end
end

# frozen_string_literal: true
class CarUpdater
  attr_reader :params, :car_photo, :user, :car

  def initialize(params, user, car)
    @car = car
    @car_photo = params.delete("car_photo")
    @params = params
    @user = user
  end

  def call
    update_car
  end

  private

  def update_car
    car.update(params)
    update_car_photo(car) if car_photo.present?
    car
  end

  def update_car_photo(car)
    car.car_photo = car_photo[:tempfile]
    car.save
  end
end

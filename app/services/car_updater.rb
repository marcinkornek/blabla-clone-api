# frozen_string_literal: true
class CarUpdater
  attr_reader :user, :car, :params, :car_photo

  def initialize(user, car, params)
    @user = user
    @car = car
    @car_photo = params.delete("car_photo")
    @params = params
  end

  def call
    return unless car && user
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

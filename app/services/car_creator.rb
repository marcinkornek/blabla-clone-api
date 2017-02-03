# frozen_string_literal: true
class CarCreator
  attr_reader :params, :car_photo, :user

  def initialize(params, user)
    @car_photo = params.delete("car_photo")
    @params = params
    @user = user
  end

  def call
    create_car
  end

  private

  def create_car
    car = user.cars.create(params)
    save_car_photo(car) if car_photo.present?
    car
  end

  def save_car_photo(car)
    car.car_photo = car_photo[:tempfile]
    car.save
  end
end

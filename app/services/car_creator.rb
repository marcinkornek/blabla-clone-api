# frozen_string_literal: true
class CarCreator
  attr_reader :user, :params, :car_photo

  def initialize(user, params)
    @user = user
    @car_photo = params.delete("car_photo")
    @params = params
  end

  def call
    return unless user
    create_car
  end

  private

  def create_car
    car = user.cars.create(params)
    save_car_photo(car) if car.valid? && car_photo.present?
    car
  end

  def save_car_photo(car)
    car.car_photo = car_photo[:tempfile]
    car.save
  end
end

# frozen_string_literal: true

class CarPolicy
  attr_reader :user, :car

  def initialize(user, car)
    @user = user
    @car = car
  end

  def create?
    user.present?
  end

  def update?
    user.present? && car.present? && car_creator?
  end

  private

  def car_creator?
    car.user == user
  end
end

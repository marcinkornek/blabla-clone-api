# frozen_string_literal: true
class UserShowSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :full_name, :email, :tel_num,
             :date_of_birth, :created_at, :updated_at, :age, :avatar, :gender,
             :role, :last_seen_at, :cars, :rides_as_driver

  def avatar
    object.avatar_mini_url
  end

  def cars
    ActiveModel::Serializer::CollectionSerializer.new(
      object.cars.limit(5),
      serializer: CarSimpleSerializer,
    )
  end

  def rides_as_driver
    ActiveModel::Serializer::CollectionSerializer.new(
      object.rides_as_driver.limit(5),
      serializer: RideAsDriverSerializer,
    )
  end
end

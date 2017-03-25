# frozen_string_literal: true
FactoryGirl.define do
  factory :ride do
    places 4
    taken_places 0
    start_date 10.days.from_now
    price 11.99
    currency "pln"
    association :car
    association :start_location, factory: :location
    association :destination_location, factory: :location
    association :driver, factory: :user
  end

  factory :other_ride, class: Ride do
    places 2
    taken_places 0
    start_date 20.days.from_now
    price 30.99
    currency "eur"
    association :car
    association :start_location, factory: :location
    association :destination_location, factory: :location
    association :driver, factory: :user
  end
end

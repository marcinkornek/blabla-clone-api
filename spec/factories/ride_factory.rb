# frozen_string_literal: true
FactoryGirl.define do
  factory :ride do
    places 4
    taken_places 0
    start_date 10.days.from_now
    price 11.99
    currency 0
    association :car
    association :start_location, factory: :location
    association :destination_location, factory: :location
    association :driver, factory: :user
  end
end

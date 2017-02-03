# frozen_string_literal: true
FactoryGirl.define do
  factory :ride_request do
    status 0
    places 2
    association :ride
    association :passenger, factory: :user
  end
end

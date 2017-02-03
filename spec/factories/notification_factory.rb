# frozen_string_literal: true
FactoryGirl.define do
  factory :notification do
    notification_type "ride_request_created"
    seen_at nil
    association :sender, factory: :user
    association :receiver, factory: :user
    association :ride
    association :ride_request
  end
end

FactoryGirl.define do
  factory :notification do
    notification_type "ride_request_created"
    seen_at "2016-09-09 23:09:14"
    sender_id association :sender, factory: :user
    receiver_id association :receiver, factory: :user
    ride_id association :ride
    ride_request_id association :ride_request
  end
end

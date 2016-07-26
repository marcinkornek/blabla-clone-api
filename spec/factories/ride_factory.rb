FactoryGirl.define do
  factory :ride do
    start_city Faker::Address.city
    start_city_lat Faker::Address.latitude
    start_city_lng Faker::Address.longitude
    destination_city Faker::Address.city
    destination_city_lat Faker::Address.latitude
    destination_city_lng Faker::Address.longitude
    places 4
    places_taken 0
    start_date 10.days.from_now
    price 11.99
    currency 0
    association :car
    association :driver, factory: :user
  end
end

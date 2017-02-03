# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"
    password_confirmation "password"
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    uid Faker::Crypto.md5
    provider "facebook"
    tel_num 888777111
    date_of_birth 20.years.ago
    role 0
  end
end

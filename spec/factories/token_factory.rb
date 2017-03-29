# frozen_string_literal: true

FactoryGirl.define do
  factory :token do
    access_token Faker::Crypto.md5
    expires_at 1.day.from_now
    association :user
  end
end

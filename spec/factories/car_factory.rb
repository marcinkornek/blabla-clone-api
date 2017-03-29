# frozen_string_literal: true

FactoryGirl.define do
  factory :car do
    brand "Ford"
    model "Focus"
    production_year "2010"
    comfort "basic"
    places 4
    color "black"
    category "hatchback"
    user

    factory :car_with_photo do
      car_photo { File.open(Rails.root.join("spec", "fixtures", "images", "car_photo.jpg")) }
    end
  end

  factory :other_car, class: Car do
    brand "Opel"
    model "Astra"
    production_year "2016"
    comfort "luxury"
    places 5
    color "red"
    category "sedan"
    user

    factory :other_car_with_photo do
      car_photo { File.open(Rails.root.join("spec", "fixtures", "images", "other_car_photo.jpg")) }
    end
  end
end

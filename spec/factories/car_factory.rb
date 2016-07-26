FactoryGirl.define do
  factory :car do
    brand 'Ford'
    model 'Focus'
    production_year '2010'
    comfort 1
    places 4
    color 1
    category 1
    user
  end
end

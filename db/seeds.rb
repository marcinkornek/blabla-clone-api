car_brands = %w(ford fiat kia honda mercedes bmw)
car_models = %w(focus 500 ceed civic slr 7)

5.times.collect do |i|
  u = User.create(
    email: "test#{i}@o2.pl",
    first_name: "first_name#{i}",
    last_name: "last_name#{i}",
    birth_year: rand(1950..1995),
    password: 'asdasdasd',
    password_confirmation: 'asdasdasd'
  )
  5.times.collect do |i|
    c = Car.create(
      brand: car_brands.sample,
      model: car_models.sample,
      comfort: Car.comforts.keys.sample,
      places: rand(1..5),
      color: Car.colors.keys.sample,
      category: Car.categories.keys.sample,
      user: u
    )
  end
end

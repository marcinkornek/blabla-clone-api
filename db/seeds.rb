car_brands = %w(ford fiat kia honda mercedes bmw)
car_models = %w(focus 500 ceed civic slr 7)
cities = [
  {name: 'Wrocław', lat: '51.1078852', lng: '17.03853760000004'},
  {name: 'Kraków', lat: '50.06465009999999', lng: '19.94497990000002'},
  {name: 'Opole', lat: '50.6751067', lng: '17.921297600000003'},
  {name: 'Zakopane', lat: '49.299181', lng: '19.94956209999998'},
  {name: 'Poznań', lat: '52.406374', lng: '16.925168100000064'},
  {name: 'Warszawa', lat: '52.2296756', lng: '21.012228700000037'}
]

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

    # future rides
    1.times.collect do |i|
      start, destination = cities.sample(2)
      fr = Ride.create(
        start_city: start[:name],
        start_city_lat: start[:lat],
        start_city_lng: start[:lng],
        destination_city: destination[:name],
        destination_city_lat: destination[:lat],
        destination_city_lng: destination[:lng],
        driver: u,
        seats: rand(1..6),
        start_date: rand(50..100).days.from_now,
        price: rand(1..50),
        currency: Ride.currencies.keys.sample,
        car: c
      )

      # future ride requests
      1.times.collect do |i|
        rr = RideRequest.create(
          passenger: User.all.sample,
          ride: fr,
          status: rand(-1..1)
        )
      end
    end


    # past rides
    1.times.collect do |i|
      start, destination = cities.sample(2)
      pr = Ride.create(
        start_city: start[:name],
        start_city_lat: start[:lat],
        start_city_lng: start[:lng],
        destination_city: destination[:name],
        destination_city_lat: destination[:lat],
        destination_city_lng: destination[:lng],
        driver: u,
        seats: rand(1..6),
        start_date: rand(1..50).days.ago,
        price: rand(1..50),
        currency: Ride.currencies.keys.sample,
        car: c
      )

      # past ride requests
      1.times.collect do |i|
        rr = RideRequest.create(
          passenger: User.all.sample,
          ride: pr,
          status: rand(-1..1)
        )
      end
    end

  end
end

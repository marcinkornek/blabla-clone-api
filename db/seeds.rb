car_brands = %w(ford fiat kia honda mercedes bmw)
car_models = %w(focus 500 ceed civic slr)
locations = [
  { country: 'Poland', address: 'Wrocław, Poland', latitude: '51.1078852', longitude: '17.03853760000004'},
  { country: 'Poland', address: 'Kraków, Poland', latitude: '50.06465009999999', longitude: '19.94497990000002'},
  { country: 'Poland', address: 'Opole, Poland', latitude: '50.6751067', longitude: '17.921297600000003'},
  { country: 'Poland', address: 'Zakopane, Poland', latitude: '49.299181', longitude: '19.94956209999998'},
  { country: 'Poland', address: 'Poznań, Poland', latitude: '52.406374', longitude: '16.925168100000064'},
  { country: 'Poland', address: 'Warszawa, Poland', latitude: '52.2296756', longitude: '21.012228700000037'}
]

locations.each do |location|
  Location.create(location)
end

5.times.collect do |i|
  u = User.create(
    email: "test#{i}@a.com",
    first_name: "first_name#{i}",
    last_name: "last_name#{i}",
    date_of_birth: rand(18..70).years.ago,
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
      fr = Ride.create(
        start_location: Location.all.sample,
        destination_location: Location.all.sample,
        driver: u,
        places: rand(1..6),
        start_date: rand(50..100).days.from_now,
        price: rand(1..50),
        currency: Ride.currencies.keys.sample,
        car: c
      )

      # future ride requests
      1.times.collect do |i|
        rr = RideRequest.create(
          passenger: User.where.not(id: u.id).sample,
          ride: fr,
          status: rand(-1..1),
          places: rand(1..fr.places)
        )
      end
    end


    # past rides
    1.times.collect do |i|
      pr = Ride.create(
        start_location: Location.all.sample,
        destination_location: Location.all.sample,
        driver: u,
        places: rand(1..6),
        start_date: rand(1..50).days.ago,
        price: rand(1..50),
        currency: Ride.currencies.keys.sample,
        car: c
      )

      # past ride requests
      1.times.collect do |i|
        rr = RideRequest.create(
          passenger: User.where.not(id: u.id).sample,
          ride: pr,
          status: rand(-1..1),
          places: rand(1..pr.places)
        )
      end
    end

  end
end

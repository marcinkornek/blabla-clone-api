5.times.collect do |i|
  User.create(
    email: "test#{i}@o2.pl",
    first_name: "first_name#{i}",
    last_name: "last_name#{i}",
    password: 'asdasdasd',
    password_confirmation: 'asdasdasd'
  )
end

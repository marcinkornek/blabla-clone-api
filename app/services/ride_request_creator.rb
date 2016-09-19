class RideRequestCreator
  attr_reader :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def call
    create_ride_request
  end

  private

  def create_ride_request
    ride_request = user.ride_requests.create(params)
    ride_request
  end
end

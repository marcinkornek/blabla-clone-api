class RidesFinder
  attr_reader :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def call
    find_rides
  end

  private

  def find_rides
    start_date = params[:start_date].to_datetime if params[:start_date].present?
    rides = Ride.other_users_rides(user).future.includes(:driver).includes(:car)
    rides = rides.without_full if params[:hide_full] == true
    rides = rides.from_city(params[:start_city]) if params[:start_city].present?
    rides = rides.to_city(params[:destination_city]) if params[:destination_city].present?
    rides = rides.in_day(start_date) if params[:start_date].present?
    rides
  end
end

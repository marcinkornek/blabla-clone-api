class RideUpdater
  attr_reader :params, :user, :ride

  def initialize(params, user, ride)
    @params = params
    @user = user
    @ride = ride
  end

  def call
    update_ride
  end

  private

  def update_ride
    start_date = params[:start_date].to_datetime if params[:start_date].present?
    ride.update(params)
    ride
  end
end

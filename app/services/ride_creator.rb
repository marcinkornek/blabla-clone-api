class RideCreator
  attr_reader :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def call
    create_ride
  end

  private

  def create_ride
    start_date = params[:start_date].to_datetime if params[:start_date].present?
    ride = user.rides_as_driver.create(params)
    ride
  end
end

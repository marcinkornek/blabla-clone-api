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
    rides = Ride.other_users_rides(user).future.includes(:driver).includes(:car)
    rides = rides.without_full if params[:hide_full] == true
    rides = rides.from_city(params[:start_city]) if params[:start_city].present?
    rides = rides.to_city(params[:destination_city]) if params[:destination_city].present?
    rides = rides.in_day(start_date) if params[:start_date].present?
    rides = filter_rides(rides) if filters.present?
    rides.order(:start_date)
  end

  def filter_rides(rides)
    # TODO use geocoder to search near start_city and destination_city
    rides = rides.from_city(start_city) if start_city.present?
    rides = rides.to_city(start_city) if destination_city.present?
    rides
  end

  def filters
    JSON.parse(params.fetch(:filters, nil)).with_indifferent_access if params[:filters].present?
  end

  def start_city
    filters&.fetch(:start_city, nil)&.fetch(:address, nil)
  end

  def destination_city
    filters&.fetch(:destination_city, nil)&.fetch(:address, nil)
  end

  def start_date
    params[:start_date].present? ? params[:start_date].to_datetime : nil
  end
end

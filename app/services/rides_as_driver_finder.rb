# frozen_string_literal: true
class RidesAsDriverFinder
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
    rides = user.rides_as_driver.includes(:driver, :start_location, :destination_location, :car)
    rides = rides.on_day(start_date) if params[:start_date].present?
    rides = search_rides(rides) if search.present?
    rides = filter_rides(rides) if filters.present?
    rides = rides.order_by_type(order_by_type)
    rides
  end

  def search_rides(rides)
    if start_location.present?
      rides = rides.from_city(start_location[:latitude], start_location[:longitude])
    end
    if destination_location.present?
      rides = rides.to_city(destination_location[:latitude], destination_location[:longitude])
    end
    rides
  end

  def filter_rides(rides)
    rides = rides.in_currency(currency) if currency.present?
    rides = rides.without_full if hide_full?
    rides = rides.future unless show_past?
    rides
  end

  def search
    JSON.parse(params.fetch(:search, nil)).with_indifferent_access if params[:search].present?
  end

  def filters
    JSON.parse(params.fetch(:filters, nil)).with_indifferent_access if params[:filters].present?
  end

  def show_past?
    filters&.fetch(:show_past, false)
  end

  def hide_full?
    filters&.fetch(:hide_full, false)
  end

  def start_location
    search&.fetch(:start_location, nil)
  end

  def destination_location
    search&.fetch(:destination_location, nil)
  end

  def start_date
    params[:start_date].present? ? params[:start_date].to_datetime : nil
  end

  def order_by_type
    filters&.fetch(:order_by_type, "newest")
  end

  def currency
    filters&.fetch(:currency, nil)
  end
end

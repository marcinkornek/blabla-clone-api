# frozen_string_literal: true

module RideFilters
  class Base
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
      rides = default_scope.includes(:driver, :start_location, :destination_location, :car)
      rides = search_rides(rides) if search.present?
      rides = filter_rides(rides) if filters.present?
      rides.order_by_type(order_by_type)
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
      rides = rides.future unless filters&.fetch(:show_past, false)
      rides = rides.without_full unless filters&.fetch(:show_full, true)
      rides = rides.other_users_rides(user) unless user || filters&.fetch(:show_as_driver, true)
      rides = rides.not_requested_rides(user) unless user || filters&.fetch(:show_requested, true)
      rides
    end

    def search
      search_params = params.fetch(:search, nil)
      JSON.parse(search_params).with_indifferent_access if search_params
    end

    def filters
      filters_params = params.fetch(:filters, nil)
      JSON.parse(filters_params).with_indifferent_access if filters_params
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
end

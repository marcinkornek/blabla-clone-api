# frozen_string_literal: true

class Ride < ApplicationRecord
  belongs_to :driver, class_name: "User"
  belongs_to :car
  has_many :passengers, dependent: :destroy, class_name: "User", through: :ride_requests
  has_many :ride_requests, dependent: :destroy
  belongs_to :start_location, class_name: "Location"
  belongs_to :destination_location, class_name: "Location"

  validates :car, presence: true
  validates :currency, presence: true
  validates :driver, presence: true
  validates :places, presence: true, numericality: { greater_than: 0, less_than: 60 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true

  enum currency: { pln: 0, usd: 1, eur: 2 }

  scope :from_city, lambda { |latitude, longitude|
    location = Location.near([latitude, longitude], 1).first
    where(start_location_id: location&.id)
  }
  scope :to_city, lambda { |latitude, longitude|
    location = Location.near([latitude, longitude], 1).first
    where(destination_location_id: location&.id)
  }
  scope :on_day, ->(date) { where(start_date: date.beginning_of_day..date.end_of_day) }
  scope :in_currency, ->(currency) { where(currency: currency) }
  scope :without_full, -> { where("rides.places > rides.taken_places") }
  scope :full, -> { where("rides.places = rides.taken_places") }
  scope :future, -> { where("rides.start_date > ?", Time.current) }
  scope :past, -> { where("rides.start_date <= ?", Time.current) }
  scope :other_users_rides, ->(user) { where.not(driver_id: user) }
  scope :not_requested_rides, ->(user) {
    joins("LEFT JOIN ride_requests ON ride_requests.ride_id = rides.id
           AND ride_requests.passenger_id = #{user.id}").where("ride_requests IS NULL")
  }
  scope :order_by_type, lambda { |type|
    case type
    when "newest"
      order(start_date: :asc)
    when "oldest"
      order(start_date: :desc)
    when "recently_added"
      order(created_at: :desc)
    when "cheapest"
      order(price: :asc)
    when "expensive"
      order(price: :desc)
    else
      order(start_date: :asc)
    end
  }

  def locations_formatted
    "#{start_location.address} - #{destination_location.address}"
  end

  def locations_formatted_shortened
    "#{start_location.address[0..10]} - #{destination_location.address[0..10]}"
  end

  def free_places_count
    places - taken_places
  end

  def places_full
    free_places_count.to_s + " " + "place".pluralize(free_places_count)
  end

  def user_requested?(user)
    ride_requests.where(passenger_id: user.id).present?
  end

  def user_ride_request(user)
    ride_requests.find_by(passenger_id: user.id)
  end

  def user_ride_request_status(user)
    ride_requests.find_by(passenger_id: user.id)&.status
  end

  def user_role(user)
    if user.id == driver_id
      "driver"
    elsif user_requested?(user)
      "passenger"
    end
  end
end

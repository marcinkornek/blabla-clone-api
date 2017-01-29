class Ride < ApplicationRecord
  belongs_to :driver, class_name: 'User'
  belongs_to :car
  has_many :passengers,    dependent: :destroy, class_name: 'User', through: :ride_requests
  has_many :ride_requests, dependent: :destroy

  validates :car, presence: true
  validates :currency, presence: true
  validates :destination_city, presence: true
  validates :destination_city_lat, presence: true
  validates :destination_city_lng, presence: true
  validates :driver, presence: true
  validates :places, presence: true, numericality: { greater_than: 0, less_than: 60 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :start_city, presence: true
  validates :start_city_lat, presence: true
  validates :start_city_lng, presence: true

  enum currency:  { pln: 0, usd: 1, eur: 2 }

  scope :from_city, ->(city) { where(start_city: city) }
  scope :to_city, ->(city) { where(destination_city: city) }
  scope :in_day, ->(date) { where(start_date: date.beginning_of_day..date.end_of_day) }
  scope :without_full, -> { where('rides.places > rides.taken_places') }
  scope :full_rides, -> { where('rides.places = rides.taken_places') }
  scope :future, -> { where('rides.start_date > ?', Time.now) }
  scope :past, -> { where('rides.start_date <= ?', Time.now) }
  scope :order_by_type, lambda { |type|
    case type
    when 'newest'
      order(start_date: :asc)
    when 'oldest'
      order(start_date: :desc)
    when 'recently_added'
      order(created_at: :desc)
    when 'cheapest'
      order(price: :asc)
    when 'expensive'
      order(price: :desc)
    else
      order(start_date: :asc)
    end
  }

  def self.other_users_rides(user)
    user.present? ? where.not(driver_id: user) : all
  end

  def free_places_count
    places - taken_places
  end

  def places_full
    free_places_count.to_s + ' ' + ('place').pluralize(free_places_count)
  end

  def user_requested?(user)
    ride_requests.where(passenger_id: user.id).present?
  end

  def user_ride_request(user)
    ride_requests.find_by(passenger_id: user.id)
  end
end

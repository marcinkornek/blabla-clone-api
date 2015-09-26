class Ride < ActiveRecord::Base
  belongs_to :driver, class_name: 'User'
  belongs_to :car
  has_many :passengers,    dependent: :destroy, class_name: 'User', through: :ride_requests
  has_many :ride_requests, dependent: :destroy

  enum currency:  { pln: 0, usd: 1, eur: 2 }

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

class Ride < ActiveRecord::Base
  belongs_to :driver, class_name: 'User'
  belongs_to :car
  has_many :passengers,    dependent: :destroy, class_name: 'User', through: :ride_requests
  has_many :ride_requests, dependent: :destroy

  enum currency:  { pln: 0, usd: 1, eur: 2 }

  def self.other_users_rides(user)
    user.present? ? where.not(driver_id: user) : all
  end

  def places_full
    places.to_s + ' ' + ('place').pluralize(places)
  end
end

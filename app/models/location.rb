class Location < ApplicationRecord
  has_many :start_rides, class_name: 'Ride', foreign_key: 'start_location_id'
  has_many :destination_rides, class_name: 'Ride', foreign_key: 'destination_location_id'
end

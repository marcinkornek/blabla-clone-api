# frozen_string_literal: true

class Location < ApplicationRecord
  geocoded_by :address

  has_many :start_rides, class_name: "Ride", foreign_key: "start_location_id"
  has_many :destination_rides, class_name: "Ride", foreign_key: "destination_location_id"
end

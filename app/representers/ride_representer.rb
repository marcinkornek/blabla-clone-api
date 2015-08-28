require 'roar/json'

module RideRepresenter
  include Roar::JSON

  property :id
  property :start_city
  property :start_city_lat
  property :start_city_lng
  property :destination_city
  property :destination_city_lat
  property :destination_city_lng
  property :seats
  property :start_date
  property :price
  property :created_at
  property :updated_at
  property :driver, extend: IndexUserRepresenter
  property :car, extend: SimpleCarRepresenter
end

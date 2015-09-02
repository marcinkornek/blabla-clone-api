require 'roar/json'

module RideAsDriverRepresenter
  include Roar::JSON

  property :id
  property :start_city
  property :destination_city
  property :places
  property :places_full
  property :start_date
  property :price
  property :currency
  property :car, extend: SimpleCarRepresenter
end

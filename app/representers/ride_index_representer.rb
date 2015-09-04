require 'roar/json'

module RideIndexRepresenter
  include Roar::JSON

  property :id
  property :start_city
  property :destination_city
  property :free_places_count
  property :places
  property :places_full
  property :start_date
  property :price
  property :currency
  property :driver, extend: UserSimpleRepresenter
  property :car,    extend: CarSimpleRepresenter
end

require 'roar/json'
require 'representable/json/collection'

module RidesAsPassengerRepresenter
  include Representable::JSON::Collection

  items extend: RideAsPassengerRepresenter
end

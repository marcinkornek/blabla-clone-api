require 'roar/json'
require 'representable/json/collection'

module RidesRepresenter
  include Representable::JSON::Collection

  items extend: RideRepresenter
end

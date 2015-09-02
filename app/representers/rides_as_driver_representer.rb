require 'roar/json'
require 'representable/json/collection'

module RidesAsDriverRepresenter
  include Representable::JSON::Collection

  items extend: RideAsDriverRepresenter
end

require 'roar/json'
require 'representable/json/collection'

module RidesIndexRepresenter
  include Representable::JSON::Collection

  items extend: RideIndexRepresenter
end

require 'roar/json'
require 'representable/json/collection'

module CarsRepresenter
  include Representable::JSON::Collection

  items extend: CarRepresenter
end

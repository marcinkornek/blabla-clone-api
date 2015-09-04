require 'roar/json'
require 'representable/json/collection'

module CarsSimpleRepresenter
  include Representable::JSON::Collection

  items extend: CarSimpleRepresenter
end

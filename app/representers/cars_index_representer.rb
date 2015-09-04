require 'roar/json'
require 'representable/json/collection'

module CarsIndexRepresenter
  include Representable::JSON::Collection

  items extend: CarIndexRepresenter
end

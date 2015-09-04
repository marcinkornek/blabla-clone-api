require 'roar/json'
require 'representable/json/collection'

module RideRequestsIndexRepresenter
  include Representable::JSON::Collection

  items extend: RideRequestIndexRepresenter
end

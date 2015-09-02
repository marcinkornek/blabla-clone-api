require 'roar/json'
require 'representable/json/collection'

module RideRequestsRepresenter
  include Representable::JSON::Collection

  items extend: RideRequestRepresenter
end

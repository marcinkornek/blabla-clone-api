require 'roar/json'

module RideRequestRepresenter
  include Roar::JSON

  property :id
  property :status
  property :created_at
  property :ride, extend: RideRepresenter
end

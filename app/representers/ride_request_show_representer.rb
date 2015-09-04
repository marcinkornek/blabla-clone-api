require 'roar/json'

module RideRequestShowRepresenter
  include Roar::JSON

  property :id
  property :status
  property :places
  property :created_at
  property :passenger, extend: UserSimpleRepresenter
end

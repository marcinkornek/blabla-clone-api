require 'roar/json'

module RideRequestIndexRepresenter
  include Roar::JSON

  property :id
  property :status
  property :places
  property :created_at
  property :passenger, extend: UserSimpleRepresenter
end

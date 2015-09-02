require 'roar/json'

module RideRequestRepresenter
  include Roar::JSON

  property :id
  property :ride, extend: RideRepresenter
  property :driver
  property :status
  property :created_at

  def driver
    ride.driver.extend(IndexUserRepresenter).to_hash
  end
end

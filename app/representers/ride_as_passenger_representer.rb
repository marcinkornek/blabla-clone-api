require 'roar/json'

module RideAsPassengerRepresenter
  include Roar::JSON

  property :id
  property :start_city
  property :destination_city
  property :free_places_count
  property :places
  property :places_full
  property :start_date
  property :price
  property :currency
  property :car
  property :driver
  property :status

  def id
    ride.id
  end

  def start_city
    ride.start_city
  end

  def destination_city
    ride.destination_city
  end

  def free_places_count
    ride.free_places_count
  end

  def places
    ride.places
  end

  def places_full
    ride.places_full
  end

  def start_date
    ride.start_date
  end

  def price
    ride.price
  end

  def currency
    ride.currency
  end

  def driver
    ride.driver.extend(IndexUserRepresenter).to_hash
  end

  def car
    ride.car.extend(SimpleCarRepresenter).to_hash
  end
end

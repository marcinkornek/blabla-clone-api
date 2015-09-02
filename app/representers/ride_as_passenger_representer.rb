require 'roar/json'

module RideAsPassengerRepresenter
  include Roar::JSON

  property :id
  property :start_city
  property :destination_city
  property :seats
  property :seats_full
  property :start_date
  property :price
  property :currency
  property :driver, extend: IndexUserRepresenter
  property :car, extend: SimpleCarRepresenter
  # property :status

  # def status
  #   request_status(current_user) if current_user.present?
  # end
end

# frozen_string_literal: true
module RideFilters
  class RidesAsPassengerFinder < Base
    def default_scope
      user.rides_as_passenger
    end
  end
end

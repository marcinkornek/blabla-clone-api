# frozen_string_literal: true
module RideFilters
  class RidesAsDriverFinder < Base
    def default_scope
      user.rides_as_driver
    end
  end
end

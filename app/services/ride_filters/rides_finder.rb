# frozen_string_literal: true

module RideFilters
  class RidesFinder < Base
    def default_scope
      Ride.future
    end
  end
end

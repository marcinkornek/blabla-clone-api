# frozen_string_literal: true
module API
  module ErrorsHelpers
    extend Grape::API::Helpers

    def unprocessable_entity(message = "Unprocessable entity")
      error!({ errors: message }, 422)
    end
  end
end

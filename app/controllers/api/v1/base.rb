# frozen_string_literal: true

module API
  module V1
    class Base < Grape::API
      version "v1", using: :header, vendor: "blabla-clone"
      format :json
      formatter :json, Grape::Formatter::ActiveModelSerializers
      prefix :api
      helpers AuthHelpers
      helpers PaginationHelpers
      helpers ErrorsHelpers

      # global handler not found case
      rescue_from ActiveRecord::RecordNotFound do |e|
        error_response(message: e.message, status: 404)
      end

      rescue_from Pundit::NotAuthorizedError do |_e|
        error!("Unauthorized.", 401)
      end

      before do
        current_user&.touch :last_seen_at
      end

      mount API::V1::CarsApi
      mount API::V1::NotificationsApi
      mount API::V1::SessionsApi
      mount API::V1::RidesApi
      mount API::V1::RideRequestsApi
      mount API::V1::UsersApi
      add_swagger_documentation base_path: "/api/v1",
                                api_version: "v1",
                                hide_documentation_path: true
    end
  end
end

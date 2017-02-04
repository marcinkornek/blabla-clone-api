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

      # global handler not found case
      rescue_from ActiveRecord::RecordNotFound do |e|
        error_response(message: e.message, status: 404)
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
    end
  end
end

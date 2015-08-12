module API
  module V1
    class Base < Grape::API
      version 'v1', using: :header, vendor: 'blabla-clone'
      format :json
      prefix :api

      # global handler not found case
      rescue_from ActiveRecord::RecordNotFound do |e|
        error_response(message: e.message, status: 404)
      end

      mount API::V1::Sessions
    end
  end
end

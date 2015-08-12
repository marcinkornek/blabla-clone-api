module Api
  module V1
    class Base < Grape::API
      version 'v1', using: :header, vendor: 'chat-app'
      format :json
      prefix :api

      # global handler not found case
      rescue_from ActiveRecord::RecordNotFound do |e|
        error_response(message: e.message, status: 404)
      end
    end
  end
end

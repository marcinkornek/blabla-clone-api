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

      helpers do
        def authenticate!
          error!('Unauthorized. Wrong email and/or invalid or expired token.', 401) unless current_user
        end

        def token
          @token ||= user.tokens.find_by(access_token: headers['X-User-Token']) if user
        end

        def user
          @user ||= User.find_by(email: headers['X-User-Email'])
        end

        def current_user
          @current_user ||= User.find(token.user_id) if token && !token.expired?
        end
      end

      mount API::V1::Sessions
    end
  end
end

# frozen_string_literal: true
module API
  module AuthHelpers
    extend Grape::API::Helpers

    def authenticate!
      unless current_user
        error!("Unauthorized. Wrong email and/or invalid or expired token.", 401)
      end
    end

    def token
      @token ||= find_user.tokens.find_by(access_token: headers["X-User-Token"]) if find_user
    end

    def find_user
      @user ||= User.find_by(email: headers["X-User-Email"])
    end

    def current_user
      @current_user ||= User.find(token.user_id) if token && !token.expired?
    end
  end
end

# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      current_user.present? ? current_user : reject_unauthorized_connection
    end

    def token
      @token ||= find_user.tokens.find_by(access_token: request.params["token"]) if find_user
    end

    def find_user
      @user ||= User.find_by(email: request.params["email"])
    end

    def current_user
      @current_user ||= User.find(token.user_id) if token && !token.expired?
    end
  end
end

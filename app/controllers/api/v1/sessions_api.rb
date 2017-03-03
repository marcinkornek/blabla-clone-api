# frozen_string_literal: true
module API
  module V1
    class SessionsApi < Grape::API
      resource :sessions do
        desc "Authenticate user with oath and return user access token"
        params do
          requires :uid, type: String, desc: "User uid"
          requires :provider, type: String, desc: "User provider"
          requires :email, type: String, desc: "User email"
          requires :first_name, type: String, desc: "User first name"
          requires :last_name, type: String, desc: "User last name"
          optional :avatar, type: String, desc: "User avatar url"
          optional :player_id, type: String, desc: "User OneSignal player_id"
        end
        post :oath_login, serializer: TokenSerializer do
          data = declared(params, include_missing: false)

          auth = data.slice(:uid, :provider, :email, :first_name, :last_name, :avatar)
          user = User.find_for_oauth(auth)
          if user
            user.update(player_id: data[:player_id]) if data[:player_id].present?
            token = user.tokens.create
            token
          end
        end

        desc "Authenticate user with email and password and return user access token"
        params do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
          optional :player_id, type: String, desc: "User OneSignal player_id"
        end
        post :login, serializer: TokenSerializer do
          data = declared(params, include_missing: false)
          email = data[:email].strip
          password = data[:password].strip

          user = User.find_by(email: email.downcase)
          unauthorized("Invalid Email and/or Password") if user.nil?
          if user.valid_password?(password)
            user.update(player_id: data[:player_id]) if data[:player_id].present?
            token = user.tokens.create
            token
          else
            unauthorized("Invalid Email and/or Password")
          end
        end

        desc "Return a user from access_token and email"
        params do
          optional :player_id, type: String, desc: "User OneSignal player_id"
        end
        get :get_user, serializer: TokenSerializer do
          authenticate!
          if token
            token.user.update(player_id: data[:player_id]) if data[:player_id].present?
            token
          else
            unauthorized("Invalid email and/or access_token")
          end
        end

        desc "Destroy the access token"
        delete do
          authenticate!
          if token
            token.destroy
            { ok: "logged out" }
          else
            unauthorized("Invalid email and/or access_token")
          end
        end
      end
    end
  end
end

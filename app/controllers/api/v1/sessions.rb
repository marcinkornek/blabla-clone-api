# frozen_string_literal: true
module API
  module V1
    class Sessions < Grape::API
      resource :sessions do
        desc "Authenticate user with oath and return user access token"
        params do
          requires :uid, type: String, desc: "User uid"
          requires :provider, type: String, desc: "User provider"
          requires :email, type: String, desc: "User email"
          requires :first_name, type: String, desc: "User first name"
          requires :last_name, type: String, desc: "User last name"
          optional :avatar, type: String, desc: "User avatar url"
        end
        post :oath_login do
          auth = params.slice(:uid, :provider, :email, :first_name, :last_name, :avatar)
          user = User.find_for_oauth(auth)
          if user
            token = user.tokens.create
            present token, with: Entities::Token
          end
        end

        desc "Authenticate user with email and password and return user access token"
        params do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
        end
        post :login do
          email = params[:email].strip
          password = params[:password].strip

          user = User.where(email: email.downcase).first
          error!({ error: "Invalid Email and/or Password" }, 401) if user.nil?
          if user.valid_password?(password)
            token = user.tokens.create
            present token, with: Entities::Token
          else
            error!({ error: "Invalid Email and/or Password." }, 401)
          end
        end

        desc "Return a user from access_token and email"
        get :get_user do
          authenticate!
          if token
            present token, with: Entities::Token
          else
            error!({ error: "Invalid email and/or access_token" }, 401)
          end
        end

        desc "Destroy the access token"
        delete do
          authenticate!
          if token
            token.destroy
            { ok: "logged out" }
          else
            error!({ error: "Invalid access token." }, 401)
          end
        end
      end
    end
  end
end

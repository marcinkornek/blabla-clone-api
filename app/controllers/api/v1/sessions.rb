module API
  module V1
    class Sessions < Grape::API
      resource :sessions do

        desc "Authenticate user with oath and return user access token"
        params do
          requires :uid,        type: String, desc: "User uid"
          requires :provider,   type: String, desc: "User provider"
          requires :email,      type: String, desc: "User email"
          requires :first_name, type: String, desc: "User first name"
          requires :last_name,  type: String, desc: "User last name"
        end
        post :oath_login do
          auth = {}
          auth[:uid]        = params[:uid]
          auth[:provider]   = params[:provider]
          auth[:email]      = params[:email]
          auth[:first_name] = params[:first_name]
          auth[:last_name]  = params[:last_name]
          user = User.find_for_oauth(auth)
          if user
            user.tokens.create.extend(TokenRepresenter)
          end
        end

        desc "Authenticate user with email and password and return user access token"
        params do
          requires :email,    type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
        end
        post :login do
          email    = params[:email]
          password = params[:password]

          user = User.where(email: email.downcase).first
          error!({error: 'Invalid Email and/or Password'}, 401) if user.nil?
          if user.valid_password?(password)
            user.tokens.create.extend(TokenRepresenter)
          else
            error!({error: 'Invalid Email and/or Password.'}, 401)
          end
        end

        desc "Destroy the access token"
        delete do
          authenticate!
          if token
            token.destroy
            {ok: 'logged out'}
          else
            error!({error: 'Invalid access token.'}, 401)
          end
        end
      end
    end
  end
end

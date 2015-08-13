module API
  module V1
    class Sessions < Grape::API
      resource :sessions do

        desc "Authenticate user with oath and return user object / access token"
        params do
          requires :uid,        type: String, desc: "User uid"
          requires :provider,   type: String, desc: "User provider"
          requires :email,      type: String, desc: "User email"
          requires :first_name, type: String, desc: "User first name"
          requires :last_name,  type: String, desc: "User last name"
        end
        post :oath_login do
          auth = {}
          auth[:uid] = params[:uid]
          auth[:provider] = params[:provider]
          auth[:email] = params[:email]
          auth[:first_name] = params[:first_name]
          auth[:last_name] = params[:last_name]
          user = User.find_for_oauth(auth)
          if user
            user.tokens.create.extend(TokenRepresenter)
          else
            'there is no such user'
          end
        end
      end
    end
  end
end

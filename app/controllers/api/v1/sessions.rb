module API
  module V1
    class Sessions < Grape::API
      resource :sessions do

        desc "Authenticate user and return user object / access token"
        params do
          requires :uid,        type: String, desc: "User uid"
          requires :provider,   type: String, desc: "User provider"
          requires :email,      type: String, desc: "User email"
        end

        post :login do
          auth = {}
          auth[:uid] = params[:uid]
          auth[:provider] = params[:provider]
          auth[:email] = params[:email]
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

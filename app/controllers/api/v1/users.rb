module API
  module V1
    class Users < Grape::API
    	resource :users do
	      desc "Return list of users"
	      get do
	        User.all.extend(UsersRepresenter)
	      end

	      desc "Return a user"
	      params do
	        requires :id, type: Integer, desc: "user id"
	      end
	      route_param :id do
	        get do
	          user.extend(UserRepresenter)
	        end
	      end

        desc "Create a user"
        params do
          requires :first_name, type: String, desc: "user first_name"
          requires :last_name,  type: String, desc: "user last_name"
          requires :email,      type: String, desc: "user email"
          requires :password,   type: String, desc: "user password"
          requires :password_confirmation, type: String, desc: "user password confirmation"
        end
        post do
          user = User.new(
            first_name: params[:first_name],
            last_name: params[:last_name],
            email: params[:email],
            password: params[:password],
            password_confirmation: params[:password_confirmation]
          )
          if user.save
            user.extend(UserRepresenter)
          else
            status 406
            user.errors.messages
          end
        end

        desc "Update a user"
        params do
          requires :id,         type: Integer, desc: "user id"
          requires :first_name, type: String, desc: "user first_name"
          requires :last_name,  type: String, desc: "user last_name"
          requires :email,      type: String, desc: "user email"
        end
        route_param :id do
          put do
            authenticate!
            if user && user_account?
              if user.update(
                  first_name: params[:first_name],
                  last_name:  params[:last_name],
                  email:      params[:email]
                )
                status 200
                user.extend(UserRepresenter)
              else
                status 406
                user.errors.messages
              end
            else
              error!({error: I18n.t('user.edit.error')}, 406)
            end
          end
        end
      end

      helpers do
        def user
          @user ||= User.find(params[:id])
        end

        def user_account?
          user.id == current_user.id
        end
      end
    end
  end
end

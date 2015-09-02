module API
  module V1
    class Users < Grape::API
    	resource :users do
	      desc "Return list of users"
	      get do
	        User.all.extend(IndexUsersRepresenter)
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

        desc "Return user cars"
        params do
          requires :id, type: Integer, desc: "user id"
        end
        route_param :id do
          get :cars do
            user.cars.extend(CarsRepresenter)
          end
        end

        desc "Return user rides as driver"
        params do
          requires :id, type: Integer, desc: "user id"
        end
        route_param :id do
          get :rides_as_driver do
            user.rides_as_driver.extend(RidesRepresenter)
          end
        end

        desc "Return user rides as passenger"
        params do
          requires :id, type: Integer, desc: "user id"
        end
        route_param :id do
          get :rides_as_passenger do
            authenticate!
            user.rides_as_passenger.extend(RidesRepresenter)
          end
        end

        desc "Create a user"
        params do
          requires :first_name, type: String, desc: "user first_name"
          requires :last_name,  type: String, desc: "user last_name"
          requires :email,      type: String, desc: "user email"
          optional :tel_num,    type: String, desc: "user telephone number"
          optional :birth_year, type: String, desc: "user birth year"
          requires :password,   type: String, desc: "user password"
          requires :password_confirmation, type: String, desc: "user password confirmation"
        end
        post do
          user = User.new(
            first_name: params[:first_name],
            last_name:  params[:last_name],
            email:      params[:email],
            password:   params[:password],
            tel_num:    params[:tel_num].presence,
            birth_year: params[:birth_year].presence,
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
          optional :tel_num,    type: String, desc: "user telephone number"
          optional :birth_year, type: String, desc: "user birth year"
          optional :avatar,     type: Hash do
            optional :image, type: String
            optional :path_name, type: String
          end
        end
        route_param :id do
          put do
            authenticate!
            if user && user_account?
              if user.update(
                  first_name: params[:first_name],
                  last_name:  params[:last_name],
                  email:      params[:email],
                  tel_num:    tel_num,
                  birth_year: birth_year
                )
                if params[:avatar].present?
                  string = params[:avatar][:image].sub(/data:image.*base64,/, '')
                  user.avatar = AppSpecificStringIO.new(params[:avatar][:path_name], Base64.decode64(string))
                  user.save
                end
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

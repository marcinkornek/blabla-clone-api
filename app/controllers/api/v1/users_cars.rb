module API
  module V1
    class UsersCars < Grape::API
      helpers API::ParamsHelper

      helpers do
        def car
          @car ||= Car.find(params[:id])
        end

        def user_car
          @user_car ||= current_user.cars.find(params[:id])
        end
      end

      resource :cars do
        desc "Return a car options"
        get :options do
          {
            colors: Car.colors.keys,
            comforts: Car.comforts.keys,
            categories: Car.categories.keys
          }
        end

        desc "Return a car"
        params do
          requires :id, type: Integer, desc: "car id"
        end
        route_param :id do
          get do
            present car, with: Entities::CarIndex
          end
        end

        desc "Create a car"
        params do
          use :car_params
        end
        post do
          authenticate!
          data = declared(params)
          car = CarCreator.new(data, current_user).call
          if car.valid?
            present car, with: Entities::CarIndex
          else
            status 406
            car.errors.messages
          end
        end

        params do
          requires :id, type: Integer, desc: "car id"
        end
        route_param :id do
          desc "Update a car"
          params do
            use :car_params
          end
          put do
            authenticate!
            data = declared(params)
            car = CarUpdater.new(data, current_user, user_car).call
            if car.valid?
              present car, with: Entities::CarIndex
            else
              status 406
              car.errors.messages
            end
          end
        end
      end
    end
  end
end

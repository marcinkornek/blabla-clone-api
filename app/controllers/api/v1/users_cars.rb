module API
  module V1
    class UsersCars < Grape::API
      helpers API::ParamsHelper

      helpers do
        def car
          @car ||= Car.find(params[:id])
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
            car.extend(CarIndexRepresenter)
          end
        end

        desc "Create a car"
        params do
          use :car_params
        end
        post do
          authenticate!
          car = Car.new(
            brand:    params[:brand],
            model:    params[:model],
            comfort:  params[:comfort],
            places:   params[:places],
            color:    params[:color],
            category: params[:category],
            production_year: params[:production_year],
            user:     current_user
          )
          if params[:car_photo].present?
            car.car_photo = params[:car_photo][:tempfile]
            car.save
          end
          if car.save
            car.extend(CarIndexRepresenter)
          else
            status 406
            car.errors.messages
          end
        end

        desc "Update a car"
        params do
          use :car_params
        end
        route_param :id do
          put do
            authenticate!
            data = declared(params)
            if car && car_owner?
              if car.update(
                  brand:    data[:brand],
                  model:    data[:model],
                  comfort:  data[:comfort],
                  places:   data[:places],
                  color:    data[:color],
                  category: data[:category],
                  production_year: data[:production_year]
                )
                if data[:car_photo].present?
                  car.car_photo = data[:car_photo][:tempfile]
                  car.save
                end
                status 200
                car.extend(CarIndexRepresenter)
              else
                status 406
                car.errors.messages
              end
            else
              error!({error: I18n.t('cars.edit.error')}, 406)
            end
          end
        end
      end
    end
  end
end

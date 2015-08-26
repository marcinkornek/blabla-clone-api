module API
  module V1
    class UsersCars < Grape::API
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
            car.extend(CarRepresenter)
          end
        end

        desc "Create a car"
        params do
          requires :brand,    type: String, desc: "car brand"
          requires :model,    type: String, desc: "car model"
          requires :comfort,  type: String, desc: "car comfort"
          requires :places,   type: String, desc: "car places"
          requires :color,    type: String, desc: "car color"
          requires :category, type: String, desc: "car category"
          requires :production_year, type: String, desc: "car production year"
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
          if car.save
            car.extend(CarRepresenter)
          else
            status 406
            car.errors.messages
          end
        end

        desc "Update a car"
        params do
          requires :id,       type: Integer, desc: "car id"
          requires :brand,    type: String, desc: "car brand"
          requires :model,    type: String, desc: "car model"
          requires :comfort,  type: String, desc: "car comfort"
          requires :places,   type: String, desc: "car places"
          requires :color,    type: String, desc: "car color"
          requires :category, type: String, desc: "car category"
        end
        route_param :id do
          put do
            authenticate!
            if car && car_owner?
              if car.update(
                  brand:    params[:brand],
                  model:    params[:model],
                  comfort:  params[:comfort],
                  places:   params[:places],
                  color:    params[:color],
                  category: params[:category],
                )
                status 200
                cars.extend(CarsRepresenter)
              else
                status 406
                cars.errors.messages
              end
            else
              error!({error: I18n.t('cars.edit.error')}, 406)
            end
          end
        end
      end

      helpers do
        def car
          @car ||= Car.find(params[:id])
        end

        def car_owner?
          car.user_id == current_user.id
        end
      end
    end
  end
end

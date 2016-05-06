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
            car.extend(CarIndexRepresenter)
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
          optional :car_photo,  type: Hash do
            optional :filename, type: String
            optional :type,     type: String
            optional :name,     type: String
            optional :tempfile
            optional :head,     type: String
          end
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
          requires :id,       type: Integer, desc: "car id"
          requires :brand,    type: String, desc: "car brand"
          requires :model,    type: String, desc: "car model"
          requires :comfort,  type: String, desc: "car comfort"
          requires :places,   type: String, desc: "car places"
          requires :color,    type: String, desc: "car color"
          requires :category, type: String, desc: "car category"
          requires :production_year, type: String, desc: "car production year"
          optional :car_photo, type: Hash do
            optional :image, type: String
            optional :path_name, type: String
          end
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
                  production_year: params[:production_year]
                )
                if params[:car_photo].present?
                  string = params[:car_photo][:image].sub(/data:image.*base64,/, '')
                  car.car_photo = AppSpecificStringIO.new(params[:car_photo][:path_name], Base64.decode64(string))
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

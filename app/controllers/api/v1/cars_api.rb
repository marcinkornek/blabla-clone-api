# frozen_string_literal: true
module API
  module V1
    class CarsApi < Grape::API
      helpers API::ParamsHelper

      helpers do
        params :car_params do
          requires :brand, type: String, desc: "car brand"
          requires :model, type: String, desc: "car model"
          requires :comfort, type: String, desc: "car comfort"
          requires :places, type: String, desc: "car places"
          requires :color, type: String, desc: "car color"
          requires :category, type: String, desc: "car category"
          requires :production_year, type: String, desc: "car production year"
          optional :car_photo, type: Hash do
            optional :filename, type: String
            optional :type, type: String
            optional :name, type: String
            optional :tempfile
            optional :head, type: String
          end
        end

        def car
          @car ||= Car.find_by(id: params[:id])
        end

        def user_car
          @user_car ||= current_user.cars.find_by(id: params[:id])
        end

        def user
          @user ||= User.find_by(id: params[:user_id])
        end
      end

      resource :cars do
        desc "Return a car options"
        get :options do
          {
            colors: Car.colors.keys,
            comforts: Car.comforts.keys,
            categories: Car.categories.keys,
          }
        end

        desc "Return user cars"
        params do
          use :pagination_params
          requires :user_id, type: Integer, desc: "user id"
        end
        get do
          data = declared(params)
          cars = user.cars
          options = { page: data[:age], per: data[:per] }
          serialized_paginated_results(cars, CarSerializer, options)
        end

        desc "Create car"
        params do
          use :car_params
        end
        post serializer: CarSerializer do
          authenticate!
          data = declared(params)
          car = CarCreator.new(data, current_user).call
          if car.valid?
            car
          else
            unprocessable_entity(car.errors.messages)
          end
        end

        params do
          requires :id, type: Integer, desc: "car id"
        end
        route_param :id do
          desc "Return car"
          get serializer: CarSerializer do
            car
          end

          desc "Update car"
          params do
            use :car_params
          end
          put serializer: CarSerializer do
            authenticate!
            data = declared(params)
            car = CarUpdater.new(data, current_user, user_car).call
            if car.valid?
              car
            else
              unprocessable_entity(car.errors.messages)
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module API
  module V1
    class UsersApi < Grape::API
      helpers API::ParamsHelper

      helpers do
        params :user_params do
          requires :first_name, type: String, desc: "user first_name"
          requires :last_name, type: String, desc: "user last_name"
          requires :email, type: String, desc: "user email"
          optional :gender, type: String, desc: "user gender"
          optional :tel_num, type: String, desc: "user telephone number"
          optional :date_of_birth, type: Date, desc: "user birth year"
          optional :avatar, type: Hash do
            optional :filename, type: String
            optional :type, type: String
            optional :name, type: String
            optional :tempfile
            optional :head, type: String
          end
        end

        def user
          @user ||= User.find(params[:id])
        end

        def user_with_includes
          @user_with_includes ||= User.includes(:cars, rides_as_driver: :car).find(params[:id])
        end
      end

      resource :users do
        desc "Return list of users"
        params do
          use :pagination_params
        end
        get do
          data = declared(params)
          users = User.all.order(:created_at)
          options = { page: data[:page], per: data[:per] }
          serialized_paginated_results(users, UserSerializer, options)
        end

        desc "Create user"
        params do
          use :user_params
          requires :password, type: String, desc: "user password"
          requires :password_confirmation, type: String, desc: "user password confirmation"
        end
        post serializer: UserSerializer do
          data = declared(params)
          created_user = UserCreator.new(data).call

          unprocessable_entity(created_user.errors.messages) unless created_user.valid?
          created_user
        end

        desc "Checks if user email is unique"
        params do
          requires :email, type: String, desc: "user email"
        end
        get :check_if_unique do
          data = declared(params)
          EmailUniquenessChecker.new(current_user, data).call
        end

        params do
          requires :id, type: Integer, desc: "user id"
        end
        route_param :id do
          desc "Return user profile"
          get :profile, serializer: UserSerializer do
            user
          end

          desc "Return user profile with cars and rides_as_driver"
          get serializer: UserShowSerializer do
            user_with_includes
          end

          desc "Update user"
          params do
            use :user_params
          end
          put serializer: UserSerializer do
            authenticate!
            data = declared(params)
            updated_user = UserUpdater.new(data, current_user).call

            unprocessable_entity(updated_user.errors.messages) unless updated_user.valid?
            updated_user
          end
        end
      end
    end
  end
end

# frozen_string_literal: true
module API
  module ParamsHelper
    extend Grape::API::Helpers

    params :pagination_params do |options = {}|
      optional :page, type: Integer, default: options.fetch(:page_default, 1),
                      desc: "Page number of search results"
      optional :per, type: Integer, default: options.fetch(:per_default, 25),
                     desc: "Number of records per page for search results"
    end

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

    params :ride_params do
      optional :start_location_country, type: String, desc: "user start location country"
      requires :start_location_address, type: String, desc: "user start location address"
      requires :start_location_latitude, type: String, desc: "user start location latitude"
      requires :start_location_longitude, type: String, desc: "user start location longitude"
      optional :destination_location_country, type: String, desc: "user destination location country"
      requires :destination_location_address, type: String, desc: "user destination location address"
      requires :destination_location_latitude, type: String, desc: "user destination location latitude"
      requires :destination_location_longitude, type: String, desc: "user destination location longitude"
      requires :places, type: Integer, desc: "user places"
      requires :start_date, type: String, desc: "user start_date"
      requires :price, type: String, desc: "user price"
      requires :currency, type: String, desc: "user currency"
      requires :car_id, type: Integer, desc: "user car_id"
    end
  end
end

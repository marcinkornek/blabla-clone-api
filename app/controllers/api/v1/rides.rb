module API
  module V1
    class Rides < Grape::API
      helpers API::ParamsHelper

      helpers do
        def ride
          @ride ||= Ride.find(params[:id])
        end

        def ride_owner?
          ride.driver.id == current_user.id if current_user.present?
        end

        def paginated_results_with_filters(results, page, per = 25)
          return { collection: results, meta: {} } if page.nil?

          collection = results.page(page).per(per)
          filters = rides_filters(results)
          {
            collection: collection,
            meta: kaminari_params(collection),
            filters: filters
          }
        end

        def rides_filters(results)
          {
            full_rides: results.full_rides.count
          }
        end
      end

      resource :rides do
        desc "Return a ride options"
        get :options do
          cars = current_user.cars.collect{|car| {id: car.id, name: car.full_name}}
          {
            currencies: Ride.currencies.keys,
            cars: cars
          }
        end

	      desc "Return list of rides"
        params do
          use :pagination_params
          optional :start_city, type: String, desc: "filter by start_city"
          optional :destination_city, type: String, desc: "filter by destination_city"
          optional :start_date, type: String, desc: "filter by start date"
          optional :hide_full, type: Boolean, desc: "hide full rides filter"
        end
	      get do
          data = declared(params)
          rides = RidesFinder.new(data, current_user).call
          results = paginated_results_with_filters(rides, params[:page], params[:per])
          present results[:collection],
                  with: Entities::RidesIndex,
                  pagination: results[:meta],
                  filters: results[:filters]
	      end

	      desc "Return a ride"
	      params do
	        requires :id, type: Integer, desc: "ride id"
	      end
	      route_param :id do
	        get do
            if ride_owner?
              present ride, with: Entities::RideShowOwner
            else current_user.present?
              present ride, with: Entities::RideShow, current_user: current_user
            end
	        end
	      end

        desc "Create a ride"
        params do
          use :ride_params
        end
        post do
          authenticate!
          start_date = params[:start_date].to_datetime if params[:start_date].present?
          ride = Ride.new(
            start_city:           params[:start_city],
            start_city_lat:       params[:start_city_lat],
            start_city_lng:       params[:start_city_lng],
            destination_city:     params[:destination_city],
            destination_city_lat: params[:destination_city_lat],
            destination_city_lng: params[:destination_city_lng],
            places:               params[:places],
            start_date:           start_date,
            price:                params[:price],
            car_id:               params[:car_id],
            currency:             params[:currency],
            driver:               current_user
          )
          if ride.save
            ride.extend(RideIndexRepresenter)
          else
            status 406
            ride.errors.messages
          end
        end

        params do
          requires :id, type: Integer, desc: "ride id"
        end
        route_param :id do
          desc "Update a ride"
          params do
            use :ride_params
          end
          put do
            authenticate!
            if ride && ride_owner?
              if params[:start_city_lat].present? && params[:destination_city_lat].present?
                ride.update(
                  start_city:           params[:start_city],
                  start_city_lat:       params[:start_city_lat],
                  start_city_lng:       params[:start_city_lng],
                  destination_city:     params[:destination_city],
                  destination_city_lat: params[:destination_city_lat],
                  destination_city_lng: params[:destination_city_lng]
                )
              end
              if ride.update(
                  places:               params[:places],
                  start_date:           params[:start_date],
                  price:                params[:price],
                  car_id:               params[:car_id],
                  currency:             params[:currency],
                )
                status 200
                ride.extend(RideIndexRepresenter)
              else
                status 406
                ride.errors.messages
              end
            else
              error!({error: I18n.t('rides.edit.error')}, 406)
            end
          end
        end
      end
    end
  end
end

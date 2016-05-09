module API
  module V1
    class Rides < Grape::API
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
          optional :page, type: Integer, desc: "page"
          optional :per, type: Integer, desc: "per"
          optional :start_city, type: String, desc: "filter by start_city"
          optional :destination_city, type: String, desc: "filter by destination_city"
          optional :date, type: String, desc: "filter by date"
          optional :hide_full, type: Boolean, desc: "hide full rides filter"
        end
	      get do
          page = params[:page] || 1
          per  = params[:per] || 25
          date = params[:date].to_datetime if params[:date].present?
	        rides = Ride.other_users_rides(current_user).includes(:driver).includes(:car)
          rides = rides.without_full if params[:hide_full] == 'true'
          rides = rides.from_city(params[:start_city]) if params[:start_city].present?
          rides = rides.to_city(params[:destination_city]) if params[:destination_city].present?
          rides = rides.in_day(date) if params[:date].present?
          results = paginated_results_with_filters(rides, page, per)
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
              ride.extend(RideShowOwnerRepresenter)
            else
              if current_user.present?
                requested = ride.user_requested?(current_user)
                ride_request = ride.user_ride_request(current_user) if requested
                ride.extend(RideShowRepresenter).to_hash.merge({user_ride_request: ride_request, requested: requested})
              else
                ride.extend(RideShowRepresenter)
              end
            end
	        end
	      end

        desc "Create a ride"
        params do
          requires :start_city,           type: String, desc: "user start_city"
          optional :start_city_lat,       type: String, desc: "user start_city_lat"
          optional :start_city_lng,       type: String, desc: "user start_city_lng"
          requires :destination_city,     type: String, desc: "user destination_city"
          optional :destination_city_lat, type: String, desc: "user destination_city_lat"
          optional :destination_city_lng, type: String, desc: "user destination_city_lng"
          requires :places,               type: Integer, desc: "user places"
          requires :start_date,           type: String, desc: "user start_date"
          requires :price,                type: String, desc: "user price"
          requires :currency,             type: String, desc: "user currency"
          requires :car_id,               type: Integer, desc: "user car_id"
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

        desc "Update a ride"
        params do
          requires :id,       type: Integer, desc: "ride id"
          requires :start_city,           type: String, desc: "user start_city"
          requires :start_city_lat,       type: String, desc: "user start_city_lat"
          requires :start_city_lng,       type: String, desc: "user start_city_lng"
          requires :destination_city,     type: String, desc: "user destination_city"
          requires :destination_city_lat, type: String, desc: "user destination_city_lat"
          requires :destination_city_lng, type: String, desc: "user destination_city_lng"
          requires :places,               type: Integer, desc: "user places"
          requires :start_date,           type: DateTime, desc: "user start_date"
          requires :price,                type: String, desc: "user price"
          requires :currency,             type: String, desc: "user currency"
          requires :car_id,               type: Integer, desc: "user car_id"
        end
        route_param :id do
          put do
            authenticate!
            if ride && ride_owner?
              if ride.update(
                  start_city:           params[:start_city],
                  start_city_lat:       params[:start_city_lat],
                  start_city_lng:       params[:start_city_lng],
                  destination_city:     params[:destination_city],
                  destination_city_lat: params[:destination_city_lat],
                  destination_city_lng: params[:destination_city_lng],
                  places:               params[:places],
                  start_date:           params[:start_date],
                  price:                params[:price],
                  car_id:               params[:car_id],
                  currency:             params[:currency],
                  driver:               current_user
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
    end
  end
end

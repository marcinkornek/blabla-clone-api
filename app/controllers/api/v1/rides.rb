module API
  module V1
    class Rides < Grape::API
      helpers API::ParamsHelper

      helpers do
        def ride
          @ride ||= Ride.includes(:driver, :car).find(params[:id])
        end

        def user_ride
          @user_ride ||= current_user.rides_as_driver.find(params[:id])
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

        desc "Create a ride"
        params do
          use :ride_params
        end
        post do
          authenticate!
          ride = RideCreator.new(params, current_user).call
          if ride.valid?
            present ride, with: Entities::RideIndex
          else
            status 406
            ride.errors.messages
          end
        end

        params do
          requires :id, type: Integer, desc: "ride id"
        end
        route_param :id do
          desc "Return a ride"
          get do
            if ride_owner?
              present ride, with: Entities::RideShowOwner
            else
              present ride, with: Entities::RideShow, current_user: current_user
            end
          end

          desc "Update a ride"
          params do
            use :ride_params
          end
          put do
            authenticate!
            data = declared(params, include_missing: false)
            ride = RideUpdater.new(data, current_user, user_ride).call
            if ride.valid?
              present ride, with: Entities::RideIndex
            else
              status 406
              ride.errors.messages
            end
          end
        end
      end
    end
  end
end

module API
  module V1
    class Rides < Grape::API
    	resource :rides do
	      desc "Return list of rides"
	      get do
	        Ride.all.includes(:driver).includes(:car).extend(RidesRepresenter)
	      end

	      desc "Return a ride"
	      params do
	        requires :id, type: Integer, desc: "ride id"
	      end
	      route_param :id do
	        get do
	          ride.extend(RideRepresenter)
	        end
	      end
      end

      helpers do
        def ride
          @ride ||= Ride.find(params[:id])
        end

        def user_ride?
          ride.id == current_user.id
        end
      end
    end
  end
end

module API
  module V1
    class RideRequests < Grape::API
    	resource :ride_requests do
        desc "Create a ride request"
        params do
          requires :ride_id, type: Integer, desc: "requested ride id"
          requires :places,  type: Integer, desc: "requested places"
        end
        post do
          authenticate!
          ride_request = RideRequest.new(
            ride_id:   params[:ride_id],
            places:    params[:places],
            passenger: current_user
          )
          if ride_request.save
            ride_request.extend(RideRequestShowRepresenter)
          else
            status 406
            ride_request.errors.messages
          end
        end
      end
    end
  end
end

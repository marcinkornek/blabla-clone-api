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

        desc "Change ride request status"
        params do
          requires :id,     type: Integer, desc: "ride request id"
          requires :status, type: String,  desc: "ride request status"
        end
        route_param :id do
          put do
            authenticate!
            if ride_request
              ride_request.update(status: params[:status])
              ride_request.ride.extend(RideShowOwnerRepresenter)
            else
              status 406
              ride_request.errors.messages
            end
          end
        end
      end

      helpers do
        def ride_request
          @ride_request ||= RideRequest.find(params[:id])
        end

        def ride_request_owner?
          ride_request.ride.driver.id == current_user.id if current_user.present?
        end
      end
    end
  end
end

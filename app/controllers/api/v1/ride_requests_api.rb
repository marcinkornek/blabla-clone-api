# frozen_string_literal: true

module API
  module V1
    class RideRequestsApi < Grape::API
      helpers API::ParamsHelper
      helpers Pundit

      helpers do
        def ride
          @ride ||= Ride.find(params[:ride_id])
        end

        def ride_request
          @ride_request ||= RideRequest.find(params[:id])
        end
      end

      resource :ride_requests do
        desc "Create a ride request"
        params do
          requires :ride_id, type: Integer, desc: "requested ride id"
          requires :places, type: Integer, desc: "requested places"
        end
        post serializer: RideShowSerializer do
          authorize(ride, :create_ride_request?)
          data = declared(params)
          created_ride_req = RideRequestCreator.new(data, current_user).call

          unprocessable_entity(created_ride_req.errors.messages) unless created_ride_req.valid?
          created_ride_req.ride
        end

        params do
          requires :id, type: Integer, desc: "ride request id"
        end
        route_param :id do
          desc "Change ride request status"
          params do
            requires :status, type: String, desc: "ride request status"
          end
          put serializer: RideShowSerializer do
            authorize(ride_request, :update?)
            data = declared(params)
            updated_ride_req = RideRequestStatusUpdater.new(data, current_user, ride_request).call

            unprocessable_entity(updated_ride_req.errors.messages) unless updated_ride_req.valid?
            updated_ride_req.reload.ride
          end
        end
      end
    end
  end
end

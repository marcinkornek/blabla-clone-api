# frozen_string_literal: true
module API
  module V1
    class RideRequestsApi < Grape::API
      helpers API::ParamsHelper

      helpers do
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
        post do
          authenticate!
          data = declared(params)
          ride_request = RideRequestCreator.new(data, current_user).call
          if ride_request.valid?
            ride = ride_request.ride
            present ride, with: Entities::RideShow, current_user: current_user
          else
            status 406
            ride_request.errors.messages
          end
        end

        params do
          requires :id, type: Integer, desc: "ride request id"
        end
        route_param :id do
          desc "Change ride request status"
          params do
            requires :status, type: String, desc: "ride request status"
          end
          put do
            authenticate!
            data = declared(params)
            rr = RideRequestStatusUpdater.new(data, current_user, ride_request).call
            if rr.valid?
              ride = rr.reload.ride
              present ride, with: Entities::RideShowOwner
            else
              status 406
              rr.errors.messages
            end
          end
        end
      end
    end
  end
end

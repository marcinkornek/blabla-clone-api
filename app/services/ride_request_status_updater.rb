# frozen_string_literal: true
class RideRequestStatusUpdater
  attr_reader :params, :user, :ride_request

  def initialize(params, user, ride_request)
    @params = params
    @user = user
    @ride_request = ride_request
  end

  def call
    update_ride_request_status
  end

  private

  def update_ride_request_status
    ride_request.update(status: params[:status])
    ride_request
  end
end

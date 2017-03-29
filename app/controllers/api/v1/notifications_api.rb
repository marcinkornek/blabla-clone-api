# frozen_string_literal: true

module API
  module V1
    class NotificationsApi < Grape::API
      helpers API::ParamsHelper

      helpers do
        def notification
          @notification ||= current_user.notifications.find(params[:id])
        end
      end

      resource :notifications do
        desc "Return current user notifications"
        params do
          use :pagination_params
        end
        get do
          authenticate!
          data = declared(params)
          notifications = current_user.notifications
            .includes(:sender, :receiver, :ride)
            .order(created_at: :desc)
          options = {
            page: data[:page],
            per: data[:per],
            unread_count: current_user.notifications.unread.count,
          }
          serialized_paginated_results(notifications, NotificationSerializer, options)
        end

        params do
          requires :id, type: Integer, desc: "notification id"
        end
        route_param :id do
          desc "Mark notification as seen"
          put :mark_as_seen, serializer: NotificationWithUnreadSerializer do
            notification.mark_as_seen!
            notification
          end
        end
      end
    end
  end
end

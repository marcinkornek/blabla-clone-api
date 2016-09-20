module API
  module V1
    class Notifications < Grape::API
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
          notifications = current_user.notifications
            .includes(:sender, :receiver, :ride)
            .order(created_at: :desc)
          results = paginated_results(notifications, params[:page], params[:per])
          present results[:collection],
                  with: Entities::Notifications,
                  pagination: results[:meta].merge(unread_count: notifications.unread.count)
        end

        params do
          requires :id, type: Integer, desc: "notification id"
        end
        route_param :id do
          desc "Mark notification as seen"
          put :mark_as_seen do
            notification.mark_as_seen!
            present notification,
                    with: Entities::NotificationWithUnreadCount,
                    current_user: current_user
          end
        end
      end
    end
  end
end

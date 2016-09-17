module API
  module V1
    class Notifications < Grape::API
      resource :notifications do
        desc "Return user notifications"
        params do
          optional :page, type: Integer, desc: "page"
          optional :per, type: Integer, desc: "per"
        end
        get do
          authenticate!
          page = params[:page] || 1
          per  = params[:per] || 25
          notifications = current_user.notifications.order(created_at: :desc)
          results = paginated_results(notifications, page, per)
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
            present notification, with: Entities::NotificationWithUnreadCount, current_user: current_user
          end
        end
      end

      helpers do
        def notification
          @notification ||= current_user.notifications.find(params[:id])
        end
      end
    end
  end
end

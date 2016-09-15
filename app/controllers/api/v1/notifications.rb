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
          notifications = current_user.notifications
          results = paginated_results(notifications, page, per)
          present results[:collection],
                  with: Entities::Notifications,
                  pagination: results[:meta]
        end
      end
    end
  end
end

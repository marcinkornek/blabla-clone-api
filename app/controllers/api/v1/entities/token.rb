module API
  module V1
    module Entities
      class Token < Grape::Entity
        expose :id
        expose :access_token
        expose :email
        expose :role

        def email
          object.user.email
        end

        def id
          object.user.id
        end

        def role
          object.user.role
        end
      end
    end
  end
end

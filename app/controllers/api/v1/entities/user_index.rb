# frozen_string_literal: true
module API
  module V1
    module Entities
      class UserIndex < Grape::Entity
        expose :id
        expose :email
        expose :full_name
        expose :created_at
        expose :age
        expose :avatar
        expose :last_seen_at

        def full_name
          object.full_name.capitalize
        end

        def avatar
          object.avatar.mini.url ||
            "https://s3-eu-west-1.amazonaws.com/blabla-clone-app/uploads/user/" \
            "avatar/placeholder/img_placeholder_avatar_thumb.jpg"
        end
      end
    end
  end
end

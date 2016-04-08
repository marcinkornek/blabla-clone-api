module API
  module V1
    module Entities
      class UserSimple < Grape::Entity
        expose :id
        expose :full_name
        expose :age
        expose :avatar

        def full_name
          object.full_name.capitalize
        end

        def avatar
          object.avatar.mini.url || 'https://s3-eu-west-1.amazonaws.com/blabla-clone-app/uploads/user/avatar/placeholder/img_placeholder_avatar_thumb.jpg'
        end
      end
    end
  end
end

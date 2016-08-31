module API
  module V1
    module Entities
      class UserShow < Grape::Entity
        expose :id
        expose :first_name
        expose :last_name
        expose :full_name
        expose :email
        expose :tel_num
        expose :date_of_birth
        expose :created_at
        expose :updated_at
        expose :age
        expose :avatar
        expose :role
        expose :last_seen_at
        expose :cars, using: Entities::CarsSimple
        expose :rides_as_driver, using: Entities::RidesAsDriver

        def first_name
          object.first_name.capitalize
        end

        def last_name
          object.last_name.capitalize
        end

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

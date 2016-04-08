module API
  module V1
    module Entities
      class UserShow < Grape::Entity
        espose :id
        espose :first_name
        espose :last_name
        espose :full_name
        espose :email
        espose :tel_num
        espose :birth_year
        espose :created_at
        espose :updated_at
        espose :age
        espose :avatar
        espose :role
        espose :last_seen_at
        espose :cars, using: Entities::CarsSimple
        espose :rides_as_driver, using: Entities::RidesAsDriver

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

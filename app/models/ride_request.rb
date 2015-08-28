class RideRequest < ActiveRecord::Base
  belongs_to :passenger, class_name: 'User'
  belongs_to :ride
end

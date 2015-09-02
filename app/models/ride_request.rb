class RideRequest < ActiveRecord::Base
  belongs_to :passenger, class_name: 'User'
  belongs_to :ride

  enum status:  { rejected: -1, pending: 0, accepted: 1 }
end

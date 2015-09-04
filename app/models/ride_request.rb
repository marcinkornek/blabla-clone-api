class RideRequest < ActiveRecord::Base
  belongs_to :passenger, class_name: 'User'
  belongs_to :ride

  enum status:  { rejected: -1, pending: 0, accepted: 1 }

  counter_culture :ride, column_name: Proc.new {|model| model.accepted? ? 'taken_places' : nil }, delta_column: 'places'
  counter_culture :ride, column_name: Proc.new {|model| model.pending? ? 'requested_places' : nil }, delta_column: 'places'
end

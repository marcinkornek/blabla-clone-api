# frozen_string_literal: true
class RideRequestSerializer < ActiveModel::Serializer
  attributes :id, :status, :places, :created_at, :updated_at

  has_one :passenger, serializer: UserSerializer
end

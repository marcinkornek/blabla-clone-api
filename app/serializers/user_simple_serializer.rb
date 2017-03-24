# frozen_string_literal: true
class UserSimpleSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :avatar

  def avatar
    object.avatar_mini_url
  end
end

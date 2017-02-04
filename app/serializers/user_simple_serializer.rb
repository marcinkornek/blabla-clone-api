# frozen_string_literal: true
class UserSimpleSerializer < ActiveModel::Serializer
  attributes :id, :email, :full_name, :created_at, :age, :avatar, :last_seen_at

  def avatar
    object.avatar_mini_url
  end
end

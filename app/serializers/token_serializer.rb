# frozen_string_literal: true
class TokenSerializer < ActiveModel::Serializer
  attributes :id, :access_token, :email, :role

  def email
    object.user.email
  end

  def id
    object.user.id
  end

  def role
    object.user.role
  end
end

# frozen_string_literal: true

# rubocop:disable Style/AlignParameters
class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :full_name, :email, :tel_num,
             :date_of_birth, :created_at, :updated_at, :age, :avatar, :gender,
             :role, :last_seen_at,

  def avatar
    object.avatar_mini_url
  end
end

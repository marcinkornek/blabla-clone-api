# frozen_string_literal: true
# rubocop:disable Style/AlignParameters
class UserSimpleSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :avatar

  def avatar
    object.avatar_mini_url
  end
end

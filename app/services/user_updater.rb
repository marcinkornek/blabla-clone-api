# frozen_string_literal: true
class UserUpdater
  attr_reader :params, :avatar, :user

  def initialize(params, user)
    @avatar = params.delete("avatar")
    @params = params
    @user = user
  end

  def call
    update_user
  end

  private

  def update_user
    user.update(params)
    update_avatar if avatar.present?
    user
  end

  def update_avatar
    user.avatar = avatar[:tempfile]
    user.save
  end
end

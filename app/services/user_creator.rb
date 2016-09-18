class UserCreator
  attr_reader :params, :avatar

  def initialize(params)
    @avatar = params.delete("avatar")
    @params = params
  end

  def call
    create_user
  end

  private

  def create_user
    user = User.new(params)
    avatar.present? ? save_avatar(user) : user.save
    user
  end

  def save_avatar(user)
    user.avatar = avatar[:tempfile]
    user.save
  end
end

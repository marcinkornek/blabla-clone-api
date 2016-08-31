require 'roar/json'

module UserIndexRepresenter
  include Roar::JSON

  property :id
  property :email
  property :full_name
  property :created_at
  property :age
  property :avatar
  property :gender
  property :last_seen_at

  def full_name
    super.capitalize
  end

  def avatar
    super.mini.url || 'https://s3-eu-west-1.amazonaws.com/blabla-clone-app/uploads/user/avatar/placeholder/img_placeholder_avatar_thumb.jpg'
  end
end

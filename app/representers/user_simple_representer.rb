require 'roar/json'

module UserSimpleRepresenter
  include Roar::JSON

  property :id
  property :full_name
  property :age
  property :avatar
  property :gender

  def full_name
    super.capitalize
  end

  def avatar
    super.mini.url || 'https://s3-eu-west-1.amazonaws.com/blabla-clone-app/uploads/user/avatar/placeholder/img_placeholder_avatar_thumb.jpg'
  end
end

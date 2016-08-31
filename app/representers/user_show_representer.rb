require 'roar/json'

module UserShowRepresenter
  include Roar::JSON

  property :id
  property :first_name
  property :last_name
  property :full_name
  property :email
  property :tel_num
  property :date_of_birth
  property :created_at
  property :updated_at
  property :age
  property :avatar
  property :gender
  property :role
  property :last_seen_at
  property :cars, extend: CarsSimpleRepresenter
  property :rides_as_driver, extend: RidesAsDriverRepresenter

  def first_name
    super.capitalize
  end

  def last_name
    super.capitalize
  end

  def full_name
    super.capitalize
  end

  def avatar
    super.mini.url || 'https://s3-eu-west-1.amazonaws.com/blabla-clone-app/uploads/user/avatar/placeholder/img_placeholder_avatar_thumb.jpg'
  end
end

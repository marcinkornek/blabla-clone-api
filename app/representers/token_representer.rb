require 'roar/json'

module TokenRepresenter
  include Roar::JSON

  property :id
  property :access_token
  property :email
  property :role

  def email
    user.email
  end

  def id
    user.id
  end

  def role
    user.role
  end
end

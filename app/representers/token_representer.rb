require 'roar/json'

module TokenRepresenter
  include Roar::JSON

  property :id
  property :access_token
  property :email

  def email
    user.email
  end

  def id
    user.id
  end
end

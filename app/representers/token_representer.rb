require 'roar/json'

module TokenRepresenter
  include Roar::JSON

  property :access_token
  property :email

  def email
    user.email
  end
end

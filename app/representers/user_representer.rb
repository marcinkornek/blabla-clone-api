require 'roar/json'

module UserRepresenter
  include Roar::JSON

  property :id
  property :first_name
  property :last_name
  property :email
  property :created_at
  property :updated_at
end

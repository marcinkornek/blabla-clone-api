require 'roar/json'
require 'representable/json/collection'

module UsersIndexRepresenter
  include Representable::JSON::Collection

  items extend: UserIndexRepresenter
end

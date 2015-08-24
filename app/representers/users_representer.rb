require 'roar/json'
require 'representable/json/collection'

module UsersRepresenter
  include Representable::JSON::Collection

  items extend: UserRepresenter
end

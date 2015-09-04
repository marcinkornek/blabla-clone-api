require 'roar/json'
require 'representable/json/collection'

module UsersSimpleRepresenter
  include Representable::JSON::Collection

  items extend: UserSimpleRepresenter
end

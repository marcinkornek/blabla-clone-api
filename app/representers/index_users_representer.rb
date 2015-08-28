require 'roar/json'
require 'representable/json/collection'

module IndexUsersRepresenter
  include Representable::JSON::Collection

  items extend: IndexUserRepresenter
end

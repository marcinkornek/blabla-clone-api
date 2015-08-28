require 'roar/json'
require 'representable/json/collection'

module SimpleCarsRepresenter
  include Representable::JSON::Collection

  items extend: SimpleCarRepresenter
end

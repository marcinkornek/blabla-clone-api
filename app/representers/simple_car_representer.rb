require 'roar/json'

module SimpleCarRepresenter
  include Roar::JSON

  property :id
  property :full_name
  property :comfort
  property :comfort_stars
  property :places_full
  property :owner_id

  def full_name
    brand.upcase + ' ' + model.upcase
  end

  def places_full
    places.to_s + ' ' + 'place'.pluralize(places)
  end

  def comfort_stars
    read_attribute('comfort') + 1 if comfort.present?
  end

  def owner_id
    user_id
  end
end

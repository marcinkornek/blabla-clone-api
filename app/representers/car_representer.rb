require 'roar/json'

module CarRepresenter
  include Roar::JSON

  property :id
  property :brand
  property :model
  property :full_name
  property :production_year
  property :comfort
  property :comfort_stars
  property :places
  property :places_full
  property :color
  property :comfort
  property :category
  property :created_at

  def brand
    super.upcase
  end

  def model
    super.upcase
  end

  def full_name
    brand.upcase + ' ' + model.upcase
  end

  def places_full
    places.to_s + ' ' + 'place'.pluralize(places)
  end

  def comfort_stars
    read_attribute('comfort') + 1 if comfort.present?
  end
end

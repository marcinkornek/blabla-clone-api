require 'roar/json'

module SimpleCarRepresenter
  include Roar::JSON

  property :id
  property :full_name
  property :comfort
  property :comfort_stars
  property :places_full
  property :owner_id
  property :car_photo

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

  def car_photo
    super.mini.url || 'https://s3-eu-west-1.amazonaws.com/blabla-clone-app/uploads/car/car_photo/placeholder/car_placeholder_thumb.jpg'
  end
end

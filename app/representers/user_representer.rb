require 'roar/json'

module UserRepresenter
  include Roar::JSON

  property :id
  property :first_name
  property :last_name
  property :full_name
  property :email
  property :created_at
  property :updated_at
  property :age

  def first_name
    super.capitalize
  end

  def last_name
    super.capitalize
  end

  def full_name
    first_name.capitalize + ' ' + last_name.capitalize
  end
end

class Car < ApplicationRecord
  belongs_to :user

  enum comfort:  { basic: 0, normal: 1, comfort: 2, luxury: 3 }
  enum color:    { black: 1, gray: 2, white: 3, red: 4, orange: 5, yellow: 6, \
                   green: 7, blue: 8, purple: 9, brown: 10, magenta: 11, \
                   cyan: 12, olive: 13, maroon: 14, navy: 15, aquamarine: 16, \
                   turquoise: 17, silver: 18, lime: 19, teal: 20, indigo: 21, \
                   violet: 22, pink: 23 }
  enum category: { sedan: 1, hatchback: 2, cabriolet: 3, combi: 4, suv: 5, \
                   minivan: 6, van: 7 }

  validates :brand,  presence: true
  validates :model,  presence: true
  validates :places, presence: true, numericality: { greater_than: 0, less_than: 60 }

  mount_uploader :car_photo, CarPhotoUploader

  def full_name
    self.brand + ' ' + self.model
  end


  def comfort_stars
    comfort.to_i + 1 if comfort.present?
  end
end

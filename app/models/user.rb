# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tokens,             dependent: :destroy
  has_many :cars,               dependent: :destroy
  has_many :rides_as_passenger, class_name: "Ride", through: :ride_requests, source: "ride"
  has_many :rides_as_driver,    class_name: "Ride", foreign_key: "driver_id"
  has_many :ride_requests,      foreign_key: "passenger_id"
  has_many :notifications,      foreign_key: "receiver_id", dependent: :destroy

  enum role: { user: 0, admin: 1 }
  enum gender: { male: 0, female: 1 }

  validates :first_name, presence: true
  validates :last_name,  presence: true

  mount_uploader :avatar, AvatarUploader

  def self.find_for_oauth(auth)
    user = User.find_by(provider: auth[:provider], uid: auth[:uid])
    if user
      return user
    elsif user_registered_with_email(auth).present?
      return user_registered_with_email(auth)
    else
      create_user_with_aouth(auth)
    end
  end

  def age
    date_of_birth ? Time.current.year - date_of_birth.year : nil
  end

  def avatar_mini_url
    avatar.mini.url || ENV["DEFAULT_AVATAR_URL"].presence
  end

  def full_name
    first_name.capitalize + " " + last_name[0].capitalize
  end

  def self.create_user_with_aouth(auth)
    user_params = user_auth_params(auth)
    user = User.create(user_params)
    user.remote_avatar_url = auth[:avatar]
    user.save
    user
  end

  def self.user_auth_params(auth)
    {
      first_name: auth[:first_name],
      last_name: auth[:last_name],
      uid: auth[:uid],
      provider: auth[:provider],
      email: auth[:email],
      password: friendly_token,
    }
  end

  def self.user_registered_with_email(auth)
    User.find_by(email: auth[:email])
  end

  def self.friendly_token
    SecureRandom.urlsafe_base64(15).tr("lIO0", "sxyz")
  end
end

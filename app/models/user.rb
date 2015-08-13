class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tokens, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence: true,
                         uniqueness: { case_sensitive: false }

  def self.find_for_oauth(auth)
    user = User.find_by(provider: auth[:provider], uid: auth[:uid])
    user || create_user_with_aouth(auth)
  end

  private

  def self.create_user_with_aouth(auth)
    User.create(
      first_name: auth[:first_name],
      last_name: auth[:last_name],
      uid: auth[:uid],
      provider: auth[:provider],
      email: auth[:email],
      password: friendly_token
    )
  end

  def self.friendly_token
    SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz')
  end
end

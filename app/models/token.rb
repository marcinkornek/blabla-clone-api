# frozen_string_literal: true

class Token < ApplicationRecord
  before_create :generate_access_token
  before_create :set_expiration
  belongs_to :user

  def expired?
    Time.current >= expires_at
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end

  def set_expiration
    self.expires_at = Time.current + 30.days
  end
end

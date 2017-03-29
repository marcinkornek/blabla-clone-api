# frozen_string_literal: true

class EmailUniquenessChecker
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    check_if_email_unique
  end

  private

  def check_if_email_unique
    user_id = user&.id
    if User.where(email: params[:email].downcase).where.not(id: user_id).exists?
      { errors: ["Email already exists"] }
    else
      { errors: [] }
    end
  end
end

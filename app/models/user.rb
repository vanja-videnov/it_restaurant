class User < ActiveRecord::Base

  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :email, presence: true, uniqueness: true, length: 6..50, format: { with: self::EMAIL_REGEXP, on: :create }
  validates :password, presence: true, length: { minimum: 6 }
  validates :telephone, format: { with: /\d{3}\d{3}\d{4}/ ,message: 'only allows numbers', allow_blank: true}
  validates :manager, inclusion: {in: [true, false]}

  def authenticate(password)
    password == self.password
  end
end

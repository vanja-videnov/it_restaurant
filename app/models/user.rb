class User < ActiveRecord::Base
  has_many :orders, dependent: :destroy

  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :email, presence: true, uniqueness: true, length: 6..50, format: {with: self::EMAIL_REGEXP, on: :create}
  validates :password, presence: true, length: {minimum: 6}, on: :create
  validates :telephone, format: {with: /\d{3}\d{3}\d{4}/, message: 'only allows numbers', allow_blank: true}
  validates :manager, inclusion: {in: [true, false]}
  before_save do
    encrypt_password if password_changed?
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.password= BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def authenticate(password)
    hash = BCrypt::Engine.hash_secret(password, self.salt)
    hash == self.password
  end
end

class User < ActiveRecord::Base

  attr_reader :password

  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, uniqueness: true

  after_initialize :ensure_session_token

  has_many :cats
  has_many :cat_rental_requests

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)

    # no user with given user_name
    return nil if user.nil?

    # check user's password
    user.is_password?(password) ? user : nil
  end

  def random_string
    SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token ||= self.random_string
    self.save!
  end

  private

  def ensure_session_token
    self.session_token ||= self.random_string
  end
end

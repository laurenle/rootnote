class User < ActiveRecord::Base
  include BCrypt

  validates :name, :email, :password_hash, presence: true
  validates :email, uniqueness: true
  has_many :folders, dependent: :destroy
  validate :valid_email?

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def valid_email?
    unless name.nil? || name.empty?
      matches = email.match(/\A([a-z|\d])(\.?([a-z|\d]))*+[@](([a-z|\d])\.?)*[a-z]+\z/)
      errors.add(:email, 'Invalid email address') if matches.to_s.empty?
    end
  end
end

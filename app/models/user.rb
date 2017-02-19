class User < ActiveRecord::Base
  include BCrypt

  validates :name, :email, :password_hash, presence: true
  validates :email, uniqueness: true
  has_many :folders, dependent: :destroy
  has_many :uploads, dependent: :destroy
  has_one :phone_number, dependent: :destroy
  validate :valid_email?

  accepts_nested_attributes_for :phone_number, allow_destroy: true, reject_if: lambda {|attributes| attributes['kind'].blank?}

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  # validate the avatar has an image extension
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

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

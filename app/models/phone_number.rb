class PhoneNumber < ApplicationRecord
  validates :number, presence: true
  belongs_to :user
  validate :valid_number?
  before_save :set_defaults

  def valid_number?
    unless number.nil?
      matches = number.match(/\A\d{3}-\d{3}-\d{4}\z/)
      errors.add(:number, 'Phone number must follow the format XXX-XXX-XXXX') if matches.to_s.empty?
    end
  end

  private
  
  def set_defaults
    self.verified = false
  end
end

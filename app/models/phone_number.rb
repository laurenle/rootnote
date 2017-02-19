class PhoneNumber < ApplicationRecord
  validates :number, presence: true
  validates :number, uniqueness: true
  belongs_to :user
  validate :valid_number?

  def valid_number?
    unless number.nil?
      matches = number.match(/\A\d{3}-\d{3}-\d{4}\z/)
      errors.add(:number, 'Phone number must follow the format XXX-XXX-XXXX') if matches.to_s.empty?
    end
  end

  def self.get_hyphenated_number(number)
    matches = number.match(/\A\+\d{11}\z/)
    unless matches.to_s.empty?
      storable = number.dup
      storable[0..1] = ''
      storable.insert(3, '-')
      storable.insert(7, '-')
    end
  end

  def self.get_textable_number(number)
    matches = number.match(/\A\d{3}-\d{3}-\d{4}\z/)
    unless matches.to_s.empty?
      textable = number.dup
      textable.gsub!('-', '')
      textable.prepend("+1")
    end
  end
end

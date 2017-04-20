class Upload < ApplicationRecord
  belongs_to :user
  has_attached_file :file
  validates_attachment_presence :file
  before_destroy :delete_from_disk

  has_attached_file :file, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  },
  path: 'public/system/:class/:hash.:extension',
  url: '/system/:class/:hash.:extension',
  hash_secret: Rails.application.secrets.url_obfuscation_token

  # validate the file has an image extension
  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/

  def file_from_url(url)
    self.file = open(url)
  end

  def delete_from_disk
    self.file.destroy
  end
end

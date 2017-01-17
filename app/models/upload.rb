class Upload < ApplicationRecord
  belongs_to :user

  has_attached_file :file, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  # validate the file has an image extension
  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/

end

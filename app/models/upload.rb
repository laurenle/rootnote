class Upload < ApplicationRecord
  belongs_to :user
  has_attached_file :file
  validates_attachment_presence :file
  before_destroy :delete_from_disk

  has_attached_file :file, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  # validate the file has an image extension
  validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/

  def delete_from_disk
    self.file.destroy
  end
end

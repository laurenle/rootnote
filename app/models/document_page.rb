class DocumentPage < ApplicationRecord
	belongs_to :pdf
	validates :number, presence: true
	validates_attachment_presence :file

	has_attached_file :image, styles: {
		thumb: '100x100>',
		large: '500x700>'
	}

	# validate the file has an image extension
	validates_attachment_content_type :file, :content_type => /\Aimage\/.*\Z/
end
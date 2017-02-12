class DocumentPage < ApplicationRecord
	belongs_to :pdf
	validates :number, presence: true

	has_attached_file :image, styles: {
		thumb: '100x100>',
		large: '500x700>'
	}

	validates_attachment_presence :image
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
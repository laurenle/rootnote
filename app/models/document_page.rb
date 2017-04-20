class DocumentPage < ApplicationRecord
	belongs_to :pdf
	validates :number, presence: true

	has_attached_file :image, styles: {
		thumb: '130x130>',
		large: '500x700>'
	},
  path: 'public/system/:class/:hash.:extension',
  url: '/system/:class/:hash.:extension',
  hash_secret: Rails.application.secrets.url_obfuscation_token

	validates_attachment_presence :image
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
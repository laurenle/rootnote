class Pdf < ApplicationRecord
	validates :name, presence: true
	belongs_to :user
	has_many :document_pages, dependent: :destroy
end

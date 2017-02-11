class Pdf < ApplicationRecord
	has_many :document_pages, dependent: :destroy
end

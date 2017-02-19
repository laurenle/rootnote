class Pdf < ApplicationRecord
	validates :name, presence: true, format: {with: /.+\.(pdf|PDF)/, message: "Must be a PDF file"}
	belongs_to :user
	has_many :document_pages, dependent: :destroy

	def populate_pages(file)
		self.name = file.original_filename
	    pdf_path = File.absolute_path(file.path)

	    # Validate before doing anything
	    return if !self.valid?

	    # Make sure it meets page limit
	    page_limit = 30
	    if PDF::Reader.new(pdf_path).page_count > page_limit
	      self.errors[:base] << "PDF must be #{page_limit} pages or less"
	      return
	    end

	    # Convert pdf to images
	    image_base_path = File.join(File.dirname(pdf_path), File.basename(pdf_path, ".*"))
	    image_path = "#{image_base_path}%d.jpg"
	    Paperclip.run("convert", "-density 150 :pdf_path -quality 90 -geometry 500x700 -alpha remove :image_path",
	                  pdf_path: pdf_path, image_path: image_path)
	    
	    # Save each page with image attachments
	    i = 0;
	    while File.exist?(image_path = "#{image_base_path}#{i}.jpg") do
	      image_file = File.open(image_path)
	      doc_page = self.document_pages.new(number: i, image: image_file)
	      image_file.close
	      File.delete(image_path)
	      i += 1
	    end
	end
end

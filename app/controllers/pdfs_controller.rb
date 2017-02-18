class PdfsController < ApplicationController
  before_action :set_pdf, only: [:show, :destroy]

  def index
    render_index
  end

  def show
    @document_pages = @pdf.document_pages.order(:number)
    render_index
  end

  def create
    @pdf = Pdf.new(pdf_params)
    pdf_file = params[:pdf][:file]
    @pdf.name = pdf_file.original_filename
    pdf_path = File.absolute_path(pdf_file.path)

    # Verify this is a pdf that meets the page limit
    page_limit = 30
    if File.extname(pdf_file.path) != ".pdf"
      @pdf.errors[:base] << "File must be a PDF"
      render_index
      return
    elsif PDF::Reader.new(pdf_path).page_count > page_limit
      @pdf.errors[:base] << "PDF must be #{page_limit} pages or less"
      render_index
      return
    end

    # Save pdf entry
    @pdf.save

    # Convert pdf to images
    image_base_path = File.join(File.dirname(pdf_path), File.basename(pdf_path, ".*"))
    image_path = "#{image_base_path}%d.jpg"
    Paperclip.run("convert", "-density 150 :pdf_path -quality 90 -geometry 500x700 -alpha remove :image_path",
                  pdf_path: pdf_path, image_path: image_path)
    
    # Save each page with image attachments
    i = 0;
    abort_pdf = false
    while File.exist?(image_path = "#{image_base_path}#{i}.jpg") do
      image_file = File.open(image_path)
      doc_page = DocumentPage.new(pdf_id: @pdf.id, number: i, image: image_file)
      if !doc_page.save
        @pdf.errors[:base] << "Problem saving PDF page #{i + 1}"
        abort_pdf = true
      end
      image_file.close
      File.delete(image_path)
      i += 1
    end

    # If something went wrong, delete the pdf
    if abort_pdf
      @pdf.destroy
    end

    render_index
  end

  def destroy
    @pdf.destroy
    render_index
  end

  private
    def set_pdf
      @pdf = Pdf.find(params[:id])
    end

    def pdf_params
      params.require(:pdf).permit(:user_id)
    end

    def render_index
      respond_to do |format|
        format.html { render partial: 'pdfs/index' }
        format.js { render partial: 'pdfs/refresh', format: 'js' }
      end
    end
end

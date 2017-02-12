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
    @pdf.name = File.basename(pdf_file.path)
    @pdf.save

    # TODO: Lots of error handling

    # Convert pdf to images
    pdf_path = File.absolute_path(pdf_file.path)
    dir = File.dirname(pdf_path)
    image_path = File.join(dir, "%d.jpg")
    Paperclip.run("convert", "-density 150 :pdf_path -quality 80 -geometry 500x700 -alpha remove :image_path",
                  pdf_path: pdf_path, image_path: image_path)
    
    # Save each page with image attachments
    i = 0;
    while File.exist?(image_path = File.join(dir, "#{i}.jpg")) do
      image_file = File.open(image_path)
      doc_page = DocumentPage.new(pdf_id: @pdf.id, number: i, image: image_file)
      doc_page.save
      image_file.close
      File.delete(image_path)
      i += 1
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
      @pdf = Pdf.new
      @pdfs = current_user.pdfs.order(created_at: :desc)

      respond_to do |format|
        format.html { render partial: 'pdfs/index' }
        format.json { render partial: 'pdfs/refresh', format: 'js' }
      end
    end
end

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

    # Populate document_pages using file
    pdf_file = params[:pdf][:file]
    @pdf.populate_pages(pdf_file)

    # Save the pdf if all went well
    @pdf.save if !@pdf.errors.any?

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

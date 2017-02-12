class DocumentPagesController < ApplicationController

  def create
    @document_page = DocumentPage.new(document_page_params)
    @document_page.save
    render nothing: true
  end

  def destroy
    @document_page.destroy
    render nothing: true
  end

  private
    def document_page_params
      params.require(:document_page).permit(:image, :number)
    end
  end
end

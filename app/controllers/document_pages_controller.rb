class DocumentPagesController < ApplicationController
  before_action :set_document_page, only: [:show, :edit, :update, :destroy]

  # GET /document_pages
  # GET /document_pages.json
  def index
    @document_pages = DocumentPage.all
  end

  # GET /document_pages/1
  # GET /document_pages/1.json
  def show
  end

  # GET /document_pages/new
  def new
    @document_page = DocumentPage.new
  end

  # GET /document_pages/1/edit
  def edit
  end

  # POST /document_pages
  # POST /document_pages.json
  def create
    @document_page = DocumentPage.new(document_page_params)

    respond_to do |format|
      if @document_page.save
        format.html { redirect_to @document_page, notice: 'Document page was successfully created.' }
        format.json { render :show, status: :created, location: @document_page }
      else
        format.html { render :new }
        format.json { render json: @document_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /document_pages/1
  # PATCH/PUT /document_pages/1.json
  def update
    respond_to do |format|
      if @document_page.update(document_page_params)
        format.html { redirect_to @document_page, notice: 'Document page was successfully updated.' }
        format.json { render :show, status: :ok, location: @document_page }
      else
        format.html { render :edit }
        format.json { render json: @document_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /document_pages/1
  # DELETE /document_pages/1.json
  def destroy
    @document_page.destroy
    respond_to do |format|
      format.html { redirect_to document_pages_url, notice: 'Document page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document_page
      @document_page = DocumentPage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_page_params
      params.require(:document_page).permit(:number)
    end
end

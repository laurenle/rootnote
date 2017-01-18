class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :destroy]

  def index
    @user = current_user
    @upload = Upload.new
    render :partial => 'uploads/index'
  end

  def create
    @upload = Upload.new(upload_params)

    if @upload.save
      render :partial => 'uploads/index', notice: 'File was successfully uploaded.'
    else
      render :partial => 'uploads/index', notice: 'There was an error while uploading your context.'
    end
  end

  def destroy
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to uploads_url, notice: 'File was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show
  end

  private
  def set_upload
    @upload = Upload.find(params[:id])
  end

  def upload_params
    params.require(:upload).permit(:file, :user_id)
  end
end
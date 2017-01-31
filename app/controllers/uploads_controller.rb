class UploadsController < ApplicationController
  before_action :set_upload, only: [:destroy]

  def index
    @user = current_user

    render partial: 'uploads/index'
  end

  def create
    @upload = Upload.new(upload_params)
    @upload.save

    respond_to do |format|
      format.html { render partial: 'uploads/index' }
      format.js { render partial: 'uploads/refresh', format: 'js' }
    end
  end

  def destroy
    @upload.destroy

    respond_to do |format|
      format.html { render partial: 'uploads/index' }
      format.js { render partial: 'uploads/refresh', format: 'js' }
    end
  end

  private
  def set_upload
    @upload = Upload.find(params[:id])
  end

  def upload_params
    params.require(:upload).permit(:file, :user_id)
  end
end
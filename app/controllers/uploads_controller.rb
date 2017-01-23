class UploadsController < ApplicationController
  before_action :set_upload, only: [:destroy]

  def index
    @user = current_user
    @upload = Upload.new
    render partial: 'uploads/index'
  end

  def create
    @upload = Upload.new(upload_params)
    @upload.save
    @upload = Upload.new

    respond_to do |format|
      format.html { render partial: 'uploads/index' }
      format.js # Use create.js.erb
    end
  end

  def destroy
    @upload.destroy
    @upload = Upload.new

    respond_to do |format|
      format.html { render partial: 'uploads/index' }
      format.js # Use destroy.js.erb
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
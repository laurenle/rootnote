class UploadsController < ApplicationController
  # CRUD actions omitted

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

  private

  def upload_params
    params.require(:upload).permit(:file, :user_id)
  end
end
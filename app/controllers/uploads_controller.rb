class UploadsController < ApplicationController
  before_action :set_upload, only: [:destroy]

  def index
    @user = current_user
    render_index
  end

  def create
    @upload = Upload.new(upload_params)
    @upload.save

    render_index
  end

  def destroy
    @upload.destroy

    render_index
  end

  private
  def set_upload
    @upload = Upload.find(params[:id])
  end

  def upload_params
    params.require(:upload).permit(:file, :user_id)
  end

  def render_index
    respond_to do |format|
      format.html { render partial: 'uploads/index' }
      format.js { render partial: 'uploads/refresh', format: 'js' }
    end
  end
end
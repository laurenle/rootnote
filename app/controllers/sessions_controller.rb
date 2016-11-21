class SessionsController < ApplicationController
  skip_before_filter :require_login

  def new
  end

  def create
    @user = User.find_by(name: params[:name])
    if @user.nil? || @user.password != params[:password]
      render :new
    else
      session[:user_id] = @user.id
      redirect_to @user
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end

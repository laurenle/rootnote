class UsersController < ApplicationController
  before_action :set_user, :verify_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :require_login, only: [:new, :create]

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @phone_number = @user.phone_number if @user.phone_number
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to edit_user_path(@user), notice: 'User was successfully created.'
      session[:user_id] = @user.id
    else
      render :new
    end
  end

  def show
    redirect_to edit_user_path(current_user)
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    reset_session
    redirect_to root_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id]) if current_user == params[:id]
    end

    def verify_user
      if session[:user_id] != params[:id].to_i
        redirect_to edit_user_path(current_user)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :email, :avatar, phone_number_attributes: [ :number, :_destroy])
    end
end

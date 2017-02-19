class PhoneNumbersController < ApplicationController
  before_action :set_phone_number, :confirm_phone_number_ownership, only: [:show, :edit, :update, :destroy]

  # GET /phone_numbers
  # GET /phone_numbers.json
  def index
    @phone_number = current_user.phone_number
  end

  # GET /phone_numbers/1/edit
  def edit
  end

  # POST /phone_numbers
  # POST /phone_numbers.json
  def create
    @phone_number = PhoneNumber.new(phone_number_params)
    @phone_number.update_attribute(:verified, false)

    respond_to do |format|
      if @phone_number.save
        Message.send_confirmation(@phone_number.number, current_user.email)
        format.html { redirect_to phone_numbers_url, notice: 'Phone number was successfully updated.' +
        ' You should receive a verification text shortly.' }
        format.json { render :show, status: :created, location: @phone_number }
      else
        format.html { render :new }
        format.json { render json: @phone_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phone_numbers/1
  # PATCH/PUT /phone_numbers/1.json
  def update
    respond_to do |format|
      if @phone_number.update(phone_number_params)
        format.html { redirect_to phone_numbers_url, notice: 'Phone number was successfully updated. ' + 
          'You should receive a verification text shortly.' }
        format.json { render :show, status: :ok, location: @phone_number }
      else
        format.html { render :edit }
        format.json { render json: @phone_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phone_numbers/1
  # DELETE /phone_numbers/1.json
  def destroy
    @phone_number.destroy
    respond_to do |format|
      format.html { redirect_to phone_numbers_url, notice: 'Phone number was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phone_number
      @phone_number = current_user.phone_number
    end

    def confirm_phone_number_ownership
      redirect_to phone_numbers_url unless @phone_number.user_id == current_user.id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phone_number_params
      params.require(:phone_number).permit(:number, :user_id)
    end
end

class CustomerUsersController < ApplicationController
  before_action :authenticate_customer_user!

  def show
    @customer_user = current_customer_user
  end

  def destroy
    if current_customer_user.destroy
      redirect_to root_path, notice: "Your account has been canceled successfully."
    else
      redirect_to customer_user_path(current_customer_user), alert: "Failed to cancel your account."
    end
  end

  def edit_profile
    @customer_user = current_customer_user
    @provinces = Province.all
  end

  def update_profile
    @customer_user = current_customer_user
    if @customer_user.update(customer_user_params)
      redirect_to customer_user_path(@customer_user), notice: "Profile updated successfully!"
    else
      @provinces = Province.all
      render :edit_profile, status: :unprocessable_entity
    end
  end

  private

  def customer_user_params
    params.require(:customer_user).permit(:name, :phone_number, :address, :province_id)
  end
end

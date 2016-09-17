class RegistrationsController < Devise::RegistrationsController
  def update
    if resource.update_with_password(account_params)
      flash[:success] = 'Account updated!'
      redirect_to edit_user_registration_path
    else
      render :edit
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :time_zone)
  end

  def account_params
    params.require(:user).permit(:email, :password, :current_password, :time_zone)
  end
end

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    return login_fail unless
        user.try(:authenticate, params[:session][:password])

    if user.activated
      log_in user
      check_remember user
      check_admin user
    else
      flash[:warning] = t "flash.check_email_acti"
      redirect_to root_url
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def check_remember user
    par = params[:session]
    par[:remember_me] == Settings.check ? remember(user) : forget(user)
  end

  def check_admin user
    if user.admin?
      redirect_back_or home_path
    else
      redirect_back_or root_url
    end
  end
end

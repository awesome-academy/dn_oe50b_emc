class UsersController < ApplicationController
  before_action :logged_in_user, :correct_user, only: [:edit, :update]
  before_action :find_and_check_user, only: %i(show edit update)

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "flash.create_success"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "flash.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params
      .require(:user).permit :name, :email, :id_card, :phone_number, :address,
                             :password, :password_confirmation
  end

  def find_and_check_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "flash.user_not_found"
    redirect_to new_user_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash.please_login"
    redirect_to login_url
  end

  def correct_user
    find_and_check_user
    redirect_to(root_url) unless current_user?(@user)
  end
end

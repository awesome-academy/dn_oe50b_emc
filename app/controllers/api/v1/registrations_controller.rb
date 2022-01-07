module Api::V1
  class RegistrationsController < Devise::RegistrationsController
    acts_as_token_authentication_handler_for User, fallback: :none
    before_action :ensure_params_exist
    skip_before_action :verify_authenticity_token

    respond_to :json

    def create
      @user = User.new user_params
      if @user.save
        render json: {message: "Registration has been completed", user: @user},
                     status: :ok
      else
        warden.custom_failure!
        render json: {message: error_messages(@user.errors.messages)},
                     status: :ok
      end
    end

    private
    def user_params
      params.require(:user).permit :email, :password, :password_confirmation
    end

    def ensure_params_exist
      return if params[:user].present?

      render json: {message: "Missing params"}, status: :unprocessable_entity
    end
  end
end

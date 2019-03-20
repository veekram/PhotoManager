class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "#{@user.identity} successfully created."
      redirect_to root_path
    else
      flash.now[:alert] = "Something went wrong. Could not create user."
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:identity, :password, :password_confirmation)
  end
end

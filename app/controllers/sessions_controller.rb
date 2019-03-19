class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(identity: params[:login][:identity].downcase)

    if user && user.authenticate(params[:login][:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in successfully.'
    else
      flash.now.alert = 'Incorrect identity or password.'
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to photos_path, notice: 'Logged out successfully.'
  end
end

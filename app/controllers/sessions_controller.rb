class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(identity: params[:login][:identity].downcase)

    if user && user.authenticate(params[:login][:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in successfully.'
    else
      identity = params.dig(:login, :identity)
      password = params.dig(:login, :password)

      @errors = if identity.blank? && password.blank?
                  ['User ID is required.', 'Password is required.']
                elsif identity.blank?
                  ['User ID is required.']
                elsif password.blank?
                  ['Password is required.']
                else
                  ['There is no user whose user ID and password match.']
                end
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to photos_path, notice: 'Logged out successfully.'
  end
end

class ApplicationController < ActionController::Base
  require 'net/http'
  require 'uri'

  CLIENT_ID     = '04e0ca43f6b6c3d1b5d5d39a271fb6dc1cb399c43a58fc50205f5004c8e3ddc2'
  CLIENT_SECRET = 'c8e8f16962b15c38254aa7ac85136cf96eedadda3aa9d7f555d174913050021d'
  REDIRECT_URI  = 'http://localhost:3000/oauth/callback'
  GRANT_TYPE    = 'authorization_code'
  TOKEN_URL     = 'https://arcane-ravine-29792.herokuapp.com/oauth/token'

  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize_user
    redirect_to login_path, notice: 'Please login.' if current_user.nil?
  end

  def callback
    url                      = URI(TOKEN_URL)

    http                     = Net::HTTP.new(url.host, url.port)
    http.use_ssl             = true
    http.verify_mode         = OpenSSL::SSL::VERIFY_NONE

    request                  = Net::HTTP::Post.new(url)
    request["content-type"]  = 'application/json'
    request["cache-control"] = 'no-cache'
    request.body             = payload.to_json

    response                 = http.request(request)

    if response
      session['access_token'] = JSON.parse(response.body)['access_token']
      flash[:notice] = 'Successfully authorized.'
    end
    redirect_to root_path
  end

  private
  def payload
    code = params.dig(:code)
    return unless code

    {
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      code: code,
      grant_type: GRANT_TYPE,
      redirect_uri: REDIRECT_URI
    }
  end
end

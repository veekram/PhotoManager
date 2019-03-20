class PhotosController < ApplicationController
  require 'net/http'
  require 'uri'

  TWEET_URL = "https://arcane-ravine-29792.herokuapp.com/api/tweets"
  LOCAL_URL = "http://localhost:3000/photos/"

  before_action :authorize_user, only: [:new, :tweet, :edit, :update, :destroy, :index]
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :tweet]

  def index
    @photos = current_user.photos.order('created_at DESC')
  end

  def show
  end

  def new
    @photo = Photo.new
  end

  def edit
  end

  def create
    @photo = current_user.photos.new(photo_params)
    photo  = params.dig(:photo, :photo)

    write_photo_to_disk(photo) if photo

    respond_to do |format|
      if @photo.save
        @photo.update_columns(photo_url: @photo_name)
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def tweet
    url                      = URI(TWEET_URL)

    http                     = Net::HTTP.new(url.host, url.port)
    http.use_ssl             = true
    http.verify_mode         = OpenSSL::SSL::VERIFY_NONE

    request                  = Net::HTTP::Post.new(url)
    request["authorization"] = "Bearer #{session[:access_token]}"
    request["content-type"]  = 'application/json'
    request.body             = payload.to_json

    response                 = http.request(request)

    if response.kind_of? Net::HTTPCreated
      flash[:notice] = "Success tweeted #{@photo.photo_url} with title #{@photo.title}"
    else
      flash[:notice] = "Something went wrong. Have you authorized this app already?"
    end

    redirect_to root_path
  end

  private
    def set_photo
      @photo = Photo.find(params[:id])
    end

    def write_photo_to_disk(photo)
      @photo_name = photo.original_filename

      File.open(Rails.root.join('app', 'assets', 'images',  @photo_name), 'wb') do |f|
        f.write(photo.read)
      end
    end

    def payload
      {
        text: "#{@photo.title}",
        url: "#{LOCAL_URL}#{@photo.photo_url}"
      }
    end
    
    def photo_params
      params.require(:photo).permit(:title, :photo, :photo_url)
    end
end

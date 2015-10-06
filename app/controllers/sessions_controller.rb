class SessionsController < ApplicationController
  def create
    begin
      puts "USER begin"
      # @user = User.from_omniauth(request.env['omniauth.auth'])
      # @user = User.new
      # @user.id = request.env['omniauth.auth']['uid']
      # @user.name = request.env['omniauth.auth']['info']['name']
      # puts "USER done"
      # puts @user.to_yaml
      auth_hash = request.env['omniauth.auth']
      @user = User.find_or_create_by(uid: auth_hash['uid'], provider: auth_hash['provider'])
      @user.name = auth_hash['info']['name']
      @user.email = auth_hash['info']['email']
      @user.image = auth_hash['info']['image']
      @user.first_name = auth_hash['info']['first_name']
      @user.last_name = auth_hash['info']['last_name']
      @user.url = auth_hash['info']['urls'][@user.provider.capitalize]
      @user.save!
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}!"
    rescue
      flash[:warning] = "There was an error while trying to authenticate you..."
      puts "OMNIAUTH"
      puts request.env["omniauth.auth"].to_yaml
    end
    redirect_to books_path
  end
end

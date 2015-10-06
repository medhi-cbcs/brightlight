class SessionsController < ApplicationController
  def create
    begin
      puts "USER begin"
      # @user = User.from_omniauth(request.env['omniauth.auth'])
      @user = User.new
      @user.id = request.env['omniauth.auth']['uid']
      @user.name = request.env['omniauth.auth']['info']['name']
      puts "USER done"
      puts @user.to_yaml
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

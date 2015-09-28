class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # For layout
  def enable_left_frame!
    @has_left_frame = true
  end
  
  def disable_left_frame!
    @has_left_frame = false
  end

  def enable_right_frame!
    @has_right_frame = true
  end
  
  def disable_right_frame!
    @has_right_frame = false
  end

end

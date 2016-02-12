class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  helper_method :current_user
  layout :layout_by_controller

  def layout_by_controller
    if params[:controller] =~ /users.*/ || params[:controller] =~ /devise\/.*/
      'user'
    elsif params[:controller] == 'welcome'
      'home'
    else
      "application"
    end
  end

  # rescue_from (ActiveRecord::RecordNotFound) { |exception| handle_exception(exception, 404) }

 #  protected

 #    def handle_exception(ex, status)
 #        render_error(ex, status)
 #        logger.error ex   
 #    end

 #    def render_error(ex, status)
 #        @status_code = status
 #        respond_to do |format|
 #          format.html { render :template => "shared/error", :status => status }
 #          format.all { render :nothing => true, :status => status }
 #       end
 #    end

end

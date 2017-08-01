# This is used for API token authentication 
# To get a token do this in terminal

#  $ curl -H "Content-Type: application/json" -X POST -d '{"user_login": {"email": "valid_user@email.com", "password": "secret-password"}}' http://localhost:3000/api/sign-in.json

# It will return a token 
# Then use that token to access the /api/carpool.json etc

class Api::BaseController < ActionController::Base
  before_action :require_login!
  helper_method :person_signed_in?, :current_user

  def user_signed_in?
    current_person.present?
  end

  def require_login!
    return true if authenticate_token
    render json: { errors: [ { detail: "Access denied" } ] }, status: 401
  end

  def current_user
    @_current_user ||= authenticate_token
  end

  private
    def authenticate_token
      authenticate_with_http_token do |token, options|
        User.find_by(auth_token: token)
      end
    end

end
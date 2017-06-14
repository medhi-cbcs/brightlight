class WelcomeController < ApplicationController
	layout 'home'
	before_action :authenticate_user!

	def index
	end

	def dashboard
 
	end

end

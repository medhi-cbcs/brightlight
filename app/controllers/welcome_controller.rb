class WelcomeController < ApplicationController
	layout 'home'
	before_action :authenticate_user!

	def index
	end

	def dashboard
	end

	def inventory_mtce
		authorize! :manage, BookLoan
	end
end

class WelcomeController < ApplicationController
	layout 'home'
	before_action :authenticate_user!

	def index
	end

	def dashboard
	end

	def inventory_mtce
		authorize! :manage, BookLoan
		@academic_years = AcademicYear.where('id>10 and id<20')
		@current_year_id = AcademicYear.current_id
	end

	def admin_mtce
		authorize! :manage, User
		@academic_years = AcademicYear.where('id>10 and id<20')
		@current_year_id = AcademicYear.current_id
	end
end

class WelcomeController < ApplicationController
	layout 'home'
	before_action :authenticate_user!

	def index
	end

	def dashboard
 
	end

	def inventory_mtce
		authorize! :manage, BookLoan
		@academic_years = AcademicYear.list_for_menu
		@current_year_id = AcademicYear.current_id
		@employees = Employee.all.order(:name)
	end

	def admin_mtce
		authorize! :manage, User
		@academic_years = AcademicYear.list_for_menu
		@current_year_id = AcademicYear.current_id
	end
end

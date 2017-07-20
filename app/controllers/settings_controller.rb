class SettingsController < ApplicationController
	layout 'home'
	before_action :authenticate_user!

  # GET /settings/inventory_mtce
  def inventory_mtce
    authorize! :manage, BookLoan
    @academic_years = AcademicYear.list_for_menu
    @current_year_id = AcademicYear.current_id
    @grade_levels = GradeLevel.all.order(:id)
    @employees = Employee.all.order(:name)
  end

  # GET /settings/admin_mtce
	def admin_mtce
		authorize! :manage, User
		@academic_years = AcademicYear.list_for_menu
		@current_year_id = AcademicYear.current_id
	end
end
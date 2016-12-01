class LoanChecksController < ApplicationController
  # GET /loan_checks
  def index
    authorize! :read, LoanCheck
    @loan_checks = LoanCheck.where(academic_year_id:params[:year] || AcademicYear.current_id)
  end 
  
  # GET /loan_check/new
  def new
    authorize! :create, LoanCheck
    @loan_check = LoanCheck.new
    @academic_year_id = params[:year] || AcademicYear.current_id
    @teacher = Employee.find params[:employee_id]
  end

  # POST /loan_check
  # POST /loan_check.json
  def create
    authorize! :create, LoanCheck
    @loan_check = LoanCheck.new(loan_check_params)

    respond_to do |format|
      if @loan_check.save
        format.html { redirect_to @loan_check.book_loan, notice: 'Book checked.' }
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @loan_check.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /loan_check/1
  # DELETE /loan_check/1.json
  def destroy
    authorize! :destroy, LoanCheck
    book_loan = @loan_check.book_loan
    @loan_check.destroy
    respond_to do |format|
      format.html { redirect_to book_loan, notice: 'Check was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def loan_check_params
      params.require(:loan_check).permit(:book_loan_id, :book_copy_id, :academic_year_id,
                                   :loaned_to, :scanned_for, :emp_flag, :matched, :user_id, :notes)
    end
end

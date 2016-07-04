class GradeSectionHistoriesController < ApplicationController
  before_action :set_grade_section_history, only: [:show]

  # GET /grade_section_histories
  # GET /grade_section_histories.json
  def index
    @grade_sections = GradeSectionHistory.all
  end

  # GET /grade_section_histories/1
  # GET /grade_section_histories/1.json
  def show
    @gss = @grade_section.students_for_academic_year(params[:year])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grade_section_history
      @grade_section = GradeSectionHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grade_section_history_params
      params.require(:grade_section_history).permit(:index, :show)
    end
end

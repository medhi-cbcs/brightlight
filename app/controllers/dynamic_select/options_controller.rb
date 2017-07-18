module DynamicSelect
  class OptionsController < ApplicationController
    respond_to :json

    def grade_sections
      @grade_sections = GradeSection.where(grade_level_id: params[:grade_level_id]).order(:grade_level_id, :id)
      respond_with(@grade_sections)
    end

    def book_labels
      @book_labels = BookLabel.for_section(params[:section])
      respond_with(@book_labels)
    end
  end
end

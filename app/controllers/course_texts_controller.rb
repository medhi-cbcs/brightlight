class CourseTextsController < ApplicationController
  before_action :set_course, only: [:index, :create]
  before_action :set_course_text, only: [:show, :edit, :update, :destroy]

  # GET /course_texts
  # GET /course_texts.json
  def index
    @course_texts = @course.course_texts
    if params[:v] == 'list'
      @view_style = :list
      session[:view_style] = 'list'
    else
      @view_style = :block
      session[:view_style] = ''
    end
  end

  # GET /course_texts/1
  # GET /course_texts/1.json
  def show
  end

  # GET /course_texts/new
  def new
    @course_text = @course.course_texts.build
  end

  # GET /course_texts/1/edit
  def edit
  end

  # POST /course_texts
  # POST /course_texts.json
  def create
    @course_text = @course.course_texts.new(course_text_params)

    respond_to do |format|
      if @course_text.save
        format.html { redirect_to course_course_texts_path(@course), notice: 'Course text was successfully created.' }
        format.json { render :show, status: :created, location: @course_text }
      else
        format.html { render :new }
        format.json { render json: @course_text.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_texts/1
  # PATCH/PUT /course_texts/1.json
  def update
    respond_to do |format|
      if @course_text.update(course_text_params)
        format.html { redirect_to course_course_texts_path(@course), notice: 'Course text was successfully updated.' }
        format.json { render :show, status: :ok, location: @course_text }
      else
        format.html { render :edit }
        format.json { render json: @course_text.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_texts/1
  # DELETE /course_texts/1.json
  def destroy
    @course_text.destroy
    respond_to do |format|
      format.html { redirect_to course_course_texts_path(@course), notice: 'Course text was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_text
      @course_text = CourseText.find(params[:id])
      @course = @course_text.course
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_text_params
      params.require(:course_text).permit(:course_id, :book_title_id)
    end
end

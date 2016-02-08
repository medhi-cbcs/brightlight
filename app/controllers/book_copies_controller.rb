class BookCopiesController < ApplicationController
  before_action :set_book_copy, only: [:show, :edit, :destroy]

  # GET /book_copies
  # GET /book_copies.json
  def index
    items_per_page = 20
    if params[:book_edition_id]
      @book_edition = BookEdition.find(params[:book_edition_id])
      @book_copies = @book_edition.book_copies.includes([:book_condition, :status]).paginate(page: params[:page], per_page: items_per_page)
      @book_copy = @book_edition.book_copies.new
      @by_condition = BookCondition.all.map {|bc| [bc, @book_edition.book_copies.select {|c| c.book_condition_id == bc.id}.count ]}
      @by_status = Status.all.map {|bc| [bc, @book_edition.book_copies.select {|c| c.status_id == bc.id}.count ]}
    else
      @book_copies = BookCopy.all
    end
  end

  # GET /book_copies/1
  # GET /book_copies/1.json
  def show
    @related_courses = @book_copy.book_title.courses if @book_copy.book_title.present?
  end

  # GET /book_copies/new
  def new
    @book_edition = BookEdition.find(params[:book_edition_id])
    @book_copy = @book_edition.book_copies.new
  end

  # GET /book_copies/1/edit
  def edit
  end

  # GET /book_copies/1/edit
  def edit_labels
    @book_edition = BookEdition.find(params[:book_edition_id])
    @book_copies = @book_edition.book_copies
    @grade_level_ids = GradeLevel.all.collect(&:id)
    @grade_sections = GradeSection.with_academic_year_id(AcademicYear.current_id)

    if params[:s].present?
      @grade_section = @grade_sections.where(id:params[:s]).first
    end
  end

  # PUT /book_copies/update_labels
  def update_labels
    begin
      book_labels = params[:book_copies].values.map {|v|{book_label_id: BookLabel.for_section_and_number(v[:grade_section_name],v[:no]).id} }
      @book_copies = BookCopy.update(params[:book_copies].keys, book_labels)
    rescue
      flash[:alert] = "Invalid input."
    end

    if @book_copies.present?
      flash[:notice] = "Book labels updated."
      book_edition_id = params[:book_edition_id]
      redirect_to book_edition_book_copies_path(book_edition_id)
    else
      redirect_to edit_labels_book_edition_book_copies_path(params[:book_edition_id])
    end
  end

  # POST /book_copies
  # POST /book_copies.json
  def create
    @book_edition = BookEdition.new(book_edition_params)

    respond_to do |format|
      if @book_edition.save
        format.html { redirect_to book_edition_book_copies_path(@book_edition), notice: 'Book copy was successfully created.' }
        format.json { render :show, status: :created, location: @book_edition }
      else
        format.html { render :new }
        format.json { render json: @book_edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_copies/1
  # PATCH/PUT /book_copies/1.json
  def update
    @book_edition = BookEdition.find(params[:book_edition_id])
    respond_to do |format|
      if @book_edition.update(book_edition_params)
        format.html { redirect_to book_edition_book_copies_path(@book_edition), notice: 'Book copy was successfully updated.' }
        format.json { render :show, status: :ok, location: @book_edition }
      else
        format.html { render :edit }
        format.json { render json: @book_edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_copies/1
  # DELETE /book_copies/1.json
  def destroy
    book_edition = @book_copy.book_edition
    @book_copy.destroy
    respond_to do |format|
      format.html { redirect_to book_edition_book_copies_path(book_edition), notice: 'Book copy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /book_copies/1/conditions
  def conditions
    @copy_conditions = CopyCondition.where(book_copy_id:params[:id]).order('created_at DESC')
    @book_copy = BookCopy.find(params[:id])
    @book_edition = @book_copy.book_edition
    @last_condition = @copy_conditions.first
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_copy
      @book_copy = BookCopy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_copy_params
      params.require(:book_copy).permit(:book_edition_id, :book_condition_id, :status_id, :barcode, :copy_no,
                                        {:book_copies => [:barcode, :grade_section_id, :no]})
    end
end
